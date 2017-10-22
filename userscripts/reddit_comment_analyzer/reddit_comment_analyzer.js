// Modeline, do not change this or userscript header
// vim: ft=javascript ts=2 sw=2 sts=2 cc=100 et
// ==UserScript==
// @name        Reddit Comment Analysis
// @namespace   reddit
// @description Quick comment analysis on reddit posts.
// @include     https://*.reddit.com/r/*/comments/*
// @version     0.1
// @grant       GM_addStyle
// @require https://unpkg.com/compromise@latest/builds/compromise.min.js
// @require https://d3js.org/d3.v4.min.js
// @require https://d3js.org/d3-scale-chromatic.v1.min.js
// ==/UserScript==
/*jshint esversion: 6 */
/* jshint -W018 */
// globals for functional reuse

// tree_data node obj prototype
function thingTreeNode(id, parentid) {
  // constructor for tree nodes.
  return {
      id       : !id ? 'DEEPTHREAD' : id,
      parent   : parentid,
      children : undefined,//let the recursion update, if problem set to []
    };
}

// comment_dict value obj prototype
function commentThing(user, parentid, comment, depth) {
  return {
    parentid         : parentid,
    parent           : function() { return document.comment_data.comment_dict[this.parentid]; },
    user             : !user ? 'LOAD_MORE_COMMENTS' : user,
    comment          : comment,
    comment_text     : function() {
      return (this.comment) ? clean_text(this.comment) : 'No comment.';
    },
    parsed_comment   : undefined,
    parse_comment    : function() {
      if(!this.parsed_comment)
        this.parsed_comment = paragraphsToNLP(this.comment_text());
      return this;
    },
    //TODO         : add topic grab function
    topic          : undefined,
    depth          : depth,
  };
}

document.comment_data = {
  tree_data          : undefined,
  comment_dict       : {},
  // comments           : {},
  // topics             : {},
  // nouns              : {},
  // TODO: make the following a single summary object.
  max_depth          : 0,
  min_vote           : 0,
  max_vote           : 0,
  update_tids        : [],  // thing IDs to that have been updated
  update_callbacks   : {},  // callbacks to pass updated thing IDs to
  previous_quantiles : undefined, // store previous quantiles so we don't have to calc again
  /* count of the number of comments */
  count_comments     : function() { return Object.keys(this.comment_dict).length; },
  /* list of thing ids that need to be updated */
  update_list        : function() { return Object.keys(this.comment_dict).filter(
    function(cid) {
      return (!document.comment_data.comment_dict[cid].parsed_comment &&
        document.comment_data.comment_dict[cid].comment !== undefined);
      });
  },
  quantiles          : function(dataset=undefined,num_buckets=100) {  // return or calc quantiles
    if(!dataset) {
      if(this.previous_quantiles) {
        return this.previous_quantiles;
      } else {
        dataset = this.vote_dataset();
      }
    }
    this.previous_quantiles = d3.scaleQuantize()
      .domain(dataset)
      .range(d3.range(num_buckets))
      .quantiles();
    return this.previous_quantiles;
  },
  vote_dataset       : function() {
    // iterate this.comment_dict and return votes
    // TODO: write function impl
    console.log('not ready yet');
    return;
  },
  to_json            : function (set='tree_data') {
    switch(set.split(':')[0]) {
      case 'tree_data':
        return JSON.stringify(this.tree_data);
      case 'flat_data':
        // TODO: write a function to make cleaner json.
        return JSON.stringify(this.comment_dict);
      case 'single_column':
        return JSON.stringify(this.comment_dict.map((k,v)=>{return [k,v[set.split(':')[1]]];}));
      default:
        throw 'Unknown set.';
    }
  },
  download          : function(set='tree_data') {
    document.download_file(
      this.to_json(set),
      filename = document.title.split(' ').join('_') + '_' + set + '.json',
      mimetype = 'application/json;charset=utf-8;');
  },
  parse_comments    : parseComments,
};
var worker = null;
$(document).ready(function() {
  //create the dialogue
  $("body").append ( `
      <div id="gmPopupContainer" class="gmStandardModal">
      <div id="exspan" class="exspan"><a href="#" id="exspana">[+]</a></div>
      <form class="gmForm"> <!-- For true form use method="POST" action="YOUR_DESIRED_URL" -->
          <!--  I will add this back in later.  For now it is a distraction and doesn't work.
          <label for="target_pronoun">Pronoun Target</label>
          <input type="text" id="target_pronoun" value="">
          <p id="current_pronoun_target">&nbsp;</p>
           -->
          <button id="gmExpandComments" type="button">Expand Comments</button>
          <button id="gmHideVisibleComments" type="button">Collapse/Hide Visible Comments ([-])</button>
          <button id="gmShowHiddenComments" type="button">Expand/Show Hidden Comments ([+])</button>
          <br/>
          <button id="gmBuildDataBtn" type="button">Build Data</button>
          <select id="gmGraphType" class="selectGraph">
            <option value="-1" selected>Choose Graph Type</option>
          </select>
          <button id="gmBuildTopicBarChartBtn" type="button">Build Topic Barchart</button>
          <button id="gmCloseDlgBtn" type="button">Close popup</button>
      </form>
        <span><a href='' id='rootlink'>Jump To Root Node</a>&nbsp;&nbsp;To download as image, right-click.</span>
        <div class="canvasdiv grabbable" id="canvasdiv">
          <section contextmenu="svgmenu">
          <menu type="context" id="svgmenu">
            <menuitem id="svg_download_menuitem" label="Download graph as SVG image" onclick="document.downloadSVG()"></menuitem>
            <menuitem id="svg_download_menuitem" label="Download graph as PNG image" onclick="document.downloadPNG()"></menuitem>
          </menu>
          <svg id="svgcanvas" class="svgcanvas" width="2000" height="2000">
            <style id="svgstyle">
              /*make sure to include svg styles with the svg!*/
              .node circle {
                fill: #999;
              }
              .node text {
                font: 10px sans-serif;
              }
              .node--internal circle {
                fill: #555;
              }
              .node--internal text {
                text-shadow: 0 1px 0 #fff, 0 -1px 0 #fff, 1px 0 0 #fff, -1px 0 0 #fff;
              }
              .link {
                fill: none;
                stroke: #555;
                stroke-opacity: 0.4;
                stroke-width: 1.5px;
              }
            </style>
          </svg>
          <img src="" id="testimage"/>
          </section>
        </div>
      <pre id="gmCSV" class="csv_selector"></pre>
      <!-- Progress bar along bottom of popup div -->
      <progress class="mainprogress" value="0" max="100"></progress>
      </div>
      <!-- <script id="worker1" type="javascript/worker">
        // This script won't be parsed by JS engines because its type is javascript/worker.
        self.onmessage = function(e) {
          self.postMessage(e.data);
        };
        // Rest of your worker code goes here.
      </script> -->
  ` );
  /*var blob = new Blob([
    document.querySelector('#worker1').textContent
  ], { type: "text/javascript" });

  // Note: window.webkitURL.createObjectURL() in Chrome 10+.
  worker = new Worker(window.URL.createObjectURL(blob));
  worker.onmessage = function(e) {
    console.log("Received: " + JSON.parse(e.data));
  };
  worker.postMessage("hello"); // Start the worker.*/

  $("#gmBuildTopicBarChartBtn").click(build_barchart);

  $("#gmBuildDataBtn").click(function () {
    build_data(true);
  });

  $("#gmExpandComments").click(function () {
    load_all_comments();
  });

  $("#copyCSVText").click( function () {
      let selector = 'gmCSV';
      $('#'+selector).show();
      $('#'+selector).text(topicsToCSV(data.topics));
      select_copy_clear(document.getElementById(selector));
      $('#'+selector).hide();
  } );

  $("#gmCloseDlgBtn").click ( function () {
    $("#gmPopupContainer").hide ();
    //$('#gmPopupContainer').css({'width': '', 'height': ''});
    //$('#gmPopupContainer').toggleClass('gmExpanded', false);
  } );

  //add analyze button
  $('ul.tabmenu').append(`
      <li>
        <a id="gmAnalyzeMenuItm" class="choice" href="#">Analyze Comments</a>

      </li>
  `);
  $('#gmAnalyzeMenuItm').click(function () { $('#gmPopupContainer').show(); });
  $('#canvasdiv').mousedown(function() {
    this.dragging = true;
    return true;
  });
  $('#canvasdiv').mouseup(function() {
    this.dragging = false;
    return true;
  });
  $('#canvasdiv').mousemove(function(event) {
    if(this.dragging) {
      this.scrollLeft += (this.ppageX-event.pageX)*0.15;
      this.scrollTop += (this.ppageY-event.pageY)*0.15;
    } else {
      this.ppageX = event.pageX;
      this.ppageY = event.pageY;
    }
    return true;
  });

  $('#gmHideVisibleComments').on('click', function(){
    var selection = $('[id^=thing_t1_]');
    console.log(selection); //why it no work!?
    selection.toggleClass('collapsed', true);
    selection.toggleClass('noncollapsed', false);
  });
  $('#gmShowHiddenComments').on('click', function(){
    $('[id^=thing_t1_]').toggleClass('collapsed', false);
    $('[id^=thing_t1_]').toggleClass('noncollapsed', true);
  });


  //--- CSS styles make it work...
  GM_addStyle ( `
    #gmPopupContainer {
      position                   : fixed;
      top                        : 10%;
      left                       : 10%;
      /*
      max-width                  : 75%;
      max-height                 : 80%;
      */
      padding                    : 2em;
      background                 : powderblue;
      border                     : 3px double black;
      border-radius              : 1ex;
      z-index                    : 777;
      display                    : none;
      overflow                   : auto; /* Enable scroll if needed */
      box-shadow                 : 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
      -webkit-animation-name     : animatetop;
      -webkit-animation-duration : 0.3s;
      animation-name             : animatetop;
      animation-duration         : 0.3s;
      -webkit-transition         : width 300ms ease-in-out, height 300ms ease-in-out;
      -moz-transition            : width 300ms ease-in-out, height 300ms ease-in-out;
      -o-transition              : width 300ms ease-in-out, height 300ms ease-in-out;
      transition                 : width 300ms ease-in-out, height 300ms ease-in-out;
    }
    /* Add 'expanded' size class */
    .gmForm {
      min-width: 800;
    }
    .gmExpanded {
      /*
      width      : 95%;
      height     : 95%;
      */
      max-width  : 75%;
      max-height : 85%;
      margin     : 0 auto;
    }
    .gmStandardModal {
      width      : 60%;
      height     : 50%;
      max-width  : 95%;
      max-height : 86%; /*this is bad, calculate*/
    }
    /* Add Animation */
    @-webkit-keyframes animatetop {
      from { top: -100px ; opacity: 0}
      to   { top: 10%    ; opacity: 1}
    }
    @keyframes animatetop {
      from { top: -100px ; opacity: 0}
      to   { top: 10%    ; opacity: 1}
    }
    #gmPopupContainer button{
      cursor : pointer;
      margin : 1em 1em 0;
      border : 1px outset buttonface;
    }
    .csv_selector {
        display : none;
        width   : 1px;
        height  : 1px;
    }
    .cv_barchart rect {
      fill: steelblue;
    }
    .cv_barchart text {
      fill: white;
      font: 10px sans-serif;
      text-anchor: end;
    }
    .mainprogress {
      width : 80%;
    }
    .canvasdiv {
      /*
      height   : 800px;
      width    : 800px;
      */
      border   : 2px solid #000;
      overflow : scroll;
      display  : none;
    }
    #rootlink {
      display: none;
    }
    .svgcanvas {
      border:1px dotted #ccc;
      background-color: #ccc;
    }
    .grabbable {
        cursor: move; /* fallback if grab cursor is unsupported */
        cursor: grab;
        cursor: -moz-grab;
        cursor: -webkit-grab;
    }

     /* (Optional) Apply a "closed-hand" cursor during drag operation. */
    .grabbable:active { 
        cursor: grabbing;
        cursor: -moz-grabbing;
        cursor: -webkit-grabbing;
    }
    .exspan {
      position : relative;
      display  : block;
      float    : right;
      hover    : none;
    }
    .exspan a{
      hover : none;
    }
  `);
  // GRAPH OPTIONS and FUNCTIONS
  graph_functions = [
    { graph_function : draw_radial,
    data_function    : get_data_accessor(),
    option_text      : 'User Radial Tree',
    },
  ];
  // add graph functions and options
  graph_sel = $('#gmGraphType');
  $.each(graph_functions, function(i,d) {
    graph_sel.append($('<option>', {
        value : i,
        text : d.option_text,
      }));
    });
  graph_sel.on('change',
    function (){
      //go ahead and clear the svg either way.
      d3.select("svg").selectAll('g').remove();
      if(+this.value>=0) {
        graph_functions[+this.value].graph_function(graph_functions[+this.value].data_function());
      }
    });
  $('#exspan').on('click', function() {
    toggle_modal_size();
  });
});

function build_barchart() {
  build_data();
  container = '#gmPopupContainer';
  //$(container).toggleClass('gmExpanded', false);
  $(container).height($(window).height()*0.8);
  var entrydata = d3.entries(data.topics).sort(getSortCallback(d3.ascending, 'count'));
  /*
    var depthmatrix = function() {
      result = [];
      try {
        for (let i in entrydata) {
          var key = entrydata[i].key;
            obj = entrydata[i].value;
          for (let di=1;di<=data.max_depth;di++) {
            result.push([di, (di in obj.depth_count) ? obj.depth_count[di] : 0, obj]);
          }
        }
        return result;
      } catch (err) {
        console.log(err.stack);
      }
    }();
    console.log(depthmatrix);
    */
  //TODO: calculate real pointsize
  //var pointsize = parseInt($(container).css('font-size')) * 72/96;
  var chartwidth = $(container).width() - 20; //20 is estimated 2em at 10px fontsize
  var barHeight = 20;
  var scale = d3.scaleLinear()
    .domain([0, entrydata[entrydata.length-1].value.count])
    .range([0, chartwidth]);
  var color_scale = d3.scaleLinear()
    .domain([entrydata[entrydata.length-1].value.count,0])
    .range([255, 100]);
  var chart = d3.select('#svgcanvas')
    .attr("width", chartwidth)
    .attr("height", barHeight * entrydata.length);
  var bar = chart.selectAll('g')
    .data(entrydata)
    .enter().append("g")
    .attr("transform", function(d, i) { return "translate(0," + i * barHeight + ")"; });
  function func_scalewidth(depth, obj) {
    return function(d, i) {return scale(obj.depth_count[depth]); };
  }
  function func_translate(offset) {
    return function(d, i) { return "translate(" + offset + ",0)"; };
  }
  function get_offset(maxdepth,objkey) {
    let offset = 0;
    for (let depth in data.topics[objkey].depth_count) {
      if(depth >= maxdepth) return offset;
      offset+=scale(data.topics[objkey].depth_count[depth]);
    }
    return offset;
  }
  var rect = bar.selectAll('rect')
    .data(function(d){
      let result = d3.entries(d.value.depth_count);
      for(let i in result){ result[i].value = [result[i].value, d.key]; }
      return result;})
    .enter().append('rect')
    .attr("transform", function(d, i) {
      return "translate(" + get_offset(d.key,d.value[1]) + ",0)";
    })
    .attr("width", function(d, i) { return scale(d.value[0]); })
    .attr("height", barHeight - 1)
    .attr("style", function(d, i) { return "fill:rgb(0,0," + color_scale(d.key) +")"; });
  /*
    bar.each(function(d,i) {
      obj = d.value;
      let offset = 0;
      for (let depth in obj.depth_count) {
        bar.append('rect')
          .attr("transform", func_translate(offset))
          .attr("width", func_scalewidth(depth, obj))
          .attr("height", barHeight - 1)
          .attr("style", "fill:rgb(0,0," + color_scale(offset) +")");
        offset+=scale(obj.depth_count[depth]);
      }
    });
    */
  bar.append("text")
    .attr("x", function(d) { return scale(d.value.count) - 3; })
    .attr("y", barHeight / 2)
    .attr("dy", ".35em")
    .text(function(d) { return d.key + ':' + d.value.count; });
}

function selectMe(elem) {
  var text = null;
  if (typeof elem === 'object') {
    text = elem;
  } else {
    text = doc.getElementById(elem);
  }
  var doc = document, range, selection;
  if (doc.body.createTextRange) {
    range = document.body.createTextRange();
    range.moveToElementText(text);
    range.select();
  } else if (window.getSelection) {
    selection = window.getSelection();
    range = document.createRange();
    range.selectNodeContents(text);
    selection.removeAllRanges();
    selection.addRange(range);
  }
}

function select_copy_clear(elem) {
  //TODO: add clear
  selectMe(elem);
  document.execCommand("copy");
}

function getSortCallback(sortcall, prop=null) {
  return function(a, b) {
    if(prop) {
      return sortcall(a.value[prop], b.value[prop]);
    } else {
      return sortcall(a.key, b.key);
    }
  };
}

function get_data_accessor(rebuild=false, format='tree') {
  if(format === 'tree') {
    return function() {
      if(rebuild || document.comment_data.tree_data === undefined) {
        document.comment_data.tree_data = thingTree();
        return thingTree();
      } else {
        return document.comment_data.tree_data;
      }
    };
  } else { // TODO: add if for format = other things
    return function () {
      //TODO: add retool of build_data function.
    };
  }
}

function build_data(rebuild=false){
  var data = document.comment_data;
  if(!Object.keys(data.comments).length || rebuild){
    data.comments = get_nested_comment_dict();
    //worker.postMessage(JSON.stringify(data.comments));
    data.topics   = count_nlp_topics(data.comments);
    //data.nouns    = count_nlp_nouns(data.comments);
    /*
    data.topic_keys = {
      pk    : Object.keys(data.topics),
      count : function(key=null){
        let result = [];
        if(!key) {
          key = Object.values(data.topics);
        }
        for(let d in key){
          if(depth in d.depth_count) {
            result.push(d.depth_count[depth]);
          }else{
            result.push(0);
          }
        }
        return result;
      },
      depth_count : function(depth, key=null) {
        let result = [];
        if(!key) {
          key = Object.values(data.topics);
        }
        for(let d in key){
          if(depth in d.depth_count) {
            result.push(d.depth_count[depth]);
          }else{
            result.push(0);
          }
        }
        return result;
      }
    };
    */
  }
}


function get_page_comments(depth=0) {
  return $('.entry').find('.usertext-body').find('.md').find('p');
}
// Test at https://jsfiddle.net/019xypLv/3/
function get_t1Things(parent){
  return parent.children('[id^=thing_t1_]');
}

function get_t1ThingByHash(hash){
  return $('#thing_t1_'+hash);
}

function get_siteTable(hash=null){
  if (hash === null){
    return $('div.commentarea').children('[id^=siteTable_t3_]');
  }else{
    return $('#siteTable_t1_'+hash);
  }
}

function get_thingAuthor(thing) {
  return thing.children('div.entry').
               children('p.tagline').
               children('a.author').text();
}

function get_thingParagraphs(thing) {
  //TODO: this isn't really ok, it finds blockquote and other things
  //and doesn't handle them correctly
  return thing.children('div.entry').
               children('form.usertext').
               children('div.md-container').
               children('div.md').find('p');
}

function get_thingParagraphClones(thing) {
  return $(thing).children('div.entry')
    .children('form.usertext')
    .children('div.md-container')
    .children('div.md').children('p').map(function(){return $(this).clone();});
}

function get_thingHTML(thing) {
  return thing.children('div.entry').
               children('form.usertext').
               children('div.md-container').
               children('div.md').html();
}

function topicsToCSV(obj) {
  var csv = '';
  try {
    $.each(obj, function(k, v) {
      if(csv === '') {
        csv += '"Topic","Count",';
        for (let i=1;i<20;i++) {
          csv += ',"DC ' + i + '"';
        }
        csv += '"Sources"';
        csv += '\n';
      }
      csv +=  '"' + k + '"' + ',' +
              v.count + ',';
      for (let i=1; i<20; i++) {
        csv+= (i in v.depth_count) ? v.depth_count[i] + ',' : '0' + ',';
      }
      csv += '"' + v.sources.join() + '"';
      csv += '\n';
    });
  } catch (err) {
    console.log(err.stack);
  }
  return csv;
}

function clean_text(clone_paragraphs) {
  //attempts to clean out child elements:
  //clone = $(elem).clone();
  // <em></em>
  // <strong></strong>
  // TODO: strikethrough handling
  $(clone_paragraphs).find('em, strong,strike,del,s').replaceWith(function() {return $(this).text();});
  // <a>...?</a> -> to inner text or LINK (for now)
  // TODO: better link handling - get head, wikipedia summary, etc...
  $(clone_paragraphs).find('a').replaceWith(function() {
    var txt = $(this).text();
    if(txt === $(this).attr('href')) return 'External Link';
    else return txt;
  });
  return $(clone_paragraphs).map(function(){return $(this).text();}).get().join('\n\n');

}
//TODO: REMOVE LINK TO DOCUMENT LATER
function paragraphsToNLP(nlstring='No comment text provided.', paragraphs=undefined) {
  //paragraphs override nlstring value
  if(paragraphs) nlstring = clean_text(paragraphs);
  try {
    return nlp(nlstring);
  } catch (err) {
    console.log('Error parsing string:');
    console.log(nlstring);
    console.log(err.stack);
    return undefined;
  }
}
//TODO: REMOVE LINK TO DOCUMENT LATER
document.paragraphsToNLP = paragraphsToNLP;

function getCommentHash(thing) {
  //get the hash for this thing
  return thing.children('p.parent').children('a').attr('name');
}

function getThingChildren(thing) {
  //return an array of children things
}

function traverse_and_add_children(collection_dict, parent_hash, depth) {
  children = get_t1Things(get_siteTable(parent_hash));
  children.each(function(ndex, el){
    child = $(el);
    hash = getCommentHash(child);
    if (typeof hash == 'undefined'){
      return;
    } else if (typeof collection_dict[parent_hash].children == 'undefined'){
      collection_dict[parent_hash].children = [hash];
    } else {
      collection_dict[parent_hash].children.push(hash);
    }
    collection_dict[hash] = {
      //thing  : child,
      document : get_comments_as_string(get_thingParagraphs(child)),
      parent   : parent_hash,
      depth    : depth,
      author   : get_thingAuthor(child)
    };
    traverse_and_add_children(collection_dict, hash, depth+1);
  });
}

function get_comments_as_string(paragraphs) {
  nlstring = '';
  paragraphs.each(function (ndex, pelem) {
    if (nlstring !== ''){
      nlstring += '\n\n' + clean_text(pelem);
    }else{
      nlstring = clean_text(pelem);
    }
  });
  return nlstring;
}

function get_nested_comment_dict() {
  //load all the comments in a flat dictionary with references to parents and
  //children by hash.
  var result = {}; //dict result
  //top-level comment things
  tlthings = get_t1Things(get_siteTable());
  tlthings.each(function(ndex, el) {
    thing = $(el);
    hash = getCommentHash(thing);
    if (hash !== undefined){
      result[hash] = {
        //thing : thing,
        document : get_comments_as_string(get_thingParagraphs(thing)),
        depth : 1,
        author : get_thingAuthor(thing)
      };
      traverse_and_add_children(result, hash, 2);
    }
  });
  return result;
}

function* nlp_comment_iter(){
  //generator to return an nlp object for each comment paragraph
  comments = get_page_comments();
  for (var cp in comments){
    yield nlp(comments[cp]);
  }
}

function getTopic(comment) {
}

function getTopics(comment) {
  var result_array = [];
  try {
    nlparsed = paragraphsToNLP(comment);
    if (!nlparsed){return ['NO NLP'];}
    topics = nlparsed.topics().out('json');
    if(topics.length > 0) {
      for (var topic in topics) {
        topic = topics[topic][0].normal;
        result_array.push(topic);
      }
    } else {
      result_array.push('NO TOPICS');
    }
    increment_progress_bar(pbsel);
  } catch (err) {
    console.log(err.stack);
  }
  return result_array;
}

function count_nlp_topics(comment_things) {
  var result = {};
  var pbsel = '.mainprogress';
  $(pbsel).attr('max', comment_things.length);
  $(pbsel).attr('value', 0);
  var offset=0;
  $.each(comment_things, function (k, v) {
    offset++;
    try {
      nlparsed = paragraphsToNLP(v.document);
      if (!nlparsed){return;}
      topics = nlparsed.topics().out('json');
      if(topics.length > 0) {
        for (var topic in topics){
          if(data.max_depth < v.depth) data.max_depth = v.depth;
          topic = topics[topic][0].normal;
          if(topic in result){
            result[topic].count++;
            result[topic].sources.push(k);
            if (v.depth in result[topic].depth_count) {
              result[topic].depth_count[v.depth]++;
            }else{
              result[topic].depth_count[v.depth] = 1;
            }
          }else{
            result[topic] = {};
            result[topic].count = 1;
            result[topic].depth_count = {};
            result[topic].depth_count[v.depth] = 1;
            result[topic].sources=[k];
          }
        }
      }
      increment_progress_bar(pbsel);
    } catch (err) {
      console.log(err.stack);
    }
  }).delay(5);
  return result;
}
function count_nlp_nouns(comment_things) {
  result = {};
  $.each(comment_things, function (k, v) {
    nlparsed = paragraphsToNLP(v.document);
    if(!nlparsed) return;
    people = nlparsed.people().out('json');
    if (people.length > 0){
      for (var person in people){
        person = people[person][0].normal;
        if(person in result){
          result[person].count++;
          if (v.depth in result[person].depth_count) {
            result[person].depth_count[v.depth]++;
          }else{
            result[person].depth_count[v.depth] = 1;
          }
        }else{
          result[person] = {};
          result[person].count = 1;
          result[person].depth_count = {};
          result[person].depth_count[v.depth] = 1;
        }
      }
    }
    nouns = nlparsed.nouns().out('json');
    if(nouns.length > 0) {
      for (var noun in nouns){
        noun = nouns[noun][0].normal;
        if(noun in result){
          result[noun].count++;
          if (v.depth in result[noun].depth_count) {
            result[noun].depth_count[v.depth]++;
          }else{
            result[noun].depth_count[v.depth] = 1;
          }
        }else{
          result[noun] = {};
          result[noun].count = 1;
          result[noun].depth_count = {};
          result[noun].depth_count[v.depth] = 1;
        }
      }
    }
  });
  return result;
}

function load_all_comments() {
  var moret1 = $('[id^=more_t1_]');
  var pbsel = '.mainprogress';
  $(pbsel).attr('max', moret1.length);
  $(pbsel).attr('value', 0);
  moret1.each(function(i,a){
    window.setTimeout(function(){$(a).click();increment_progress_bar(pbsel);},i*1000);
  });
}

function increment_progress_bar(bar, amount=1) {
  //increase a progress bar by 1 slice
  $(bar).attr('value', parseInt($(bar).attr('value'), 10)+amount);
}

function parseComments() {
  // set timeout-based topic loading for first part of generator.
  function* chunkgen (array, offset=0, length=100) {
    //returns the next callback func
    for(var ndex=offset; (ndex < offset+length && ndex < array.length); ndex++) {
      yield array[ndex];
    }
  }
  function* gengen(array, chunksize=100) {
    //returns a genorator for the next chunk of callback funcs
    for(var ndex = 0; ndex < Math.ceil(array.length / chunksize); ndex++) {
      yield {iter : chunkgen(array,offset=ndex*chunksize,length=chunksize), index : ndex};
    }
  }
  function promise_func(chunk) {
    return function(resolve, reject) {
      var parsed_ids = [];
      for(var cb of chunk.iter){parsed_ids.push(cb());}
      window.setTimeout(function() {
        resolve(parsed_ids);// return the ids we parsed
      },300);
    };
  }
  function* promisegen(chunks) {
    for(var chunk of chunks) {
      yield new Promise(promise_func(chunk));
    }
  }
  // filtered list of ids to parse
  var update_ids = document.comment_data.update_list();
  // set up our progress bar..
  var pbsel = '.mainprogress';
  $(pbsel).attr('max', update_ids.length);
  $(pbsel).attr('value', 0);
  // comment parse closure
  function parse_closure(cid){
    return function() {
        return document.comment_data.comment_dict[cid].parse_comment().id;
      };
  }
  // now filter the list of parse functions
  var promises = promisegen(gengen(update_ids.map(function(k,v){
      return parse_closure(k);
    })));
  var promise  = promises.next();
  function resolve(readylist) {
      console.log(readylist);
      /*for(var id in readylist) {
        //TODO: remove log call, add new update_thing function
        //console.log('This is where I should update thing id "' + id + '"');
        //update_thing(id);
      }*/
      increment_progress_bar(pbsel, amount=readylist.length);
    }
  while(!promise.done) {
    promise.value.then(resolve);
    promise = promises.next();
  }
}

function thingTree() {
  var OP = $('div[id^=thing_t3]');
  var parse_nlp_funcs = [];
  function get_thing_info(t1thing, parent, depth=1){
    var treenode = new thingTreeNode(
      $(t1thing).attr('id').split('_')[2], //id
      parent);
    // TODO: write getAccessPath function
    if(treenode.id) document.comment_data.comment_dict[treenode.id] = new commentThing(
        $(t1thing).children('div.entry').children('p.tagline').children('a.author').text(), //user
        parent,
        get_thingParagraphClones($(t1thing)),
        depth);

    // TODO: move to worker thread instead of an array of functions.
    /*parse_nlp_funcs.push(function(cid){return function() {
      // parse topics...
      //TODO: repair
      document.comment_data.comment_dict[cid].parsed_comment = paragraphsToNLP(
        document.comment_data.comment_dict[cid].comment);
      return cid;
    };}(treenode.id));*/
    if(document.comment_data.max_depth<depth) document.comment_data.max_depth=depth;
    var direct_children = $(t1thing).children('div.child').children('div[id^=siteTable_t1]')
        .children('div[id^=thing_t1_]');
    if(direct_children.length)
      treenode.children = direct_children.map(function(){
          return get_thing_info(this,treenode.id,depth+1);
        }).get();
    return treenode;
  }
  // set timeout-based topic loading for first part of generator.
  /*function* array_offset_chunk (array, offset=0, length=100) {
    //returns the next callback func
    for(var ndex=offset; (ndex < offset+length && ndex < array.length); ndex++) {
      yield array[ndex];
    }
  }
  function* iterator_iterator(array) {
    //returns a genorator for the next chunk of callback funcs
    for(var ndex = 0; ndex < Math.ceil(array.length / 100); ndex++) {
      yield {iter : array_offset_chunk(array,offset=ndex*100), index : ndex};
    }
  }
  var iterfuncs = iterator_iterator(parse_nlp_funcs);*/
  /*var pbsel = '.mainprogress';
  $(pbsel).attr('max', parse_nlp_funcs.length);
  $(pbsel).attr('value', 0);*/
  /*for(let nextitr of iterfuncs) {
    window.setTimeout(function() {
      for(let pfunc of nextitr.iter) {
        document.comment_data.update_tids.push(pfunc());
        increment_progress_bar(pbsel);
      }
      call_updates();
    },100*nextitr.index);
  }*/
  // TODO: if necessary, move this to flat data as well.
  var OPid = OP.attr('id').split('_')[2];
  document.comment_data.comment_dict[OPid] = new commentThing(
        OP.find('div.entry div.top-matter p.tagline a.author').text(), //user
        OPid,
        undefined,
        0);
  return {
    id       : OPid,
    parent   : OPid,
    children : $('div[id^=siteTable_t3]').children('div[id^=thing_t1_]').map(function(){
        return get_thing_info(this,OPid);
      }).get(),
  };
}

function call_updates() {
  //iterate over updated tids and call any update callbacks registered
  var size = document.comment_data.update_tids.length; //capture the size now since we consume.
  var tid;
  for(var i=0; i<size; i++) {
    try {
      tid = document.comment_data.update_tids.shift(); //FIFO
      if(!tid) break; //if tid is undefined it means our array is empty, race cond.
      var cb = document.comment_data.update_callbacks[tid].shift(); //CB FIFO
      while(cb) {
        cb(tid); //call any callbacks for this tid
        cb = document.comment_data.update_callbacks[tid].shift();
      }
    } catch (err) {
      //push the failed tid back on until a cb has been added.
      if(tid) document.comment_data.update_tids.push(tid);
    }
  }
}

function downloadSVG(type='graph') {
  var serializer = new XMLSerializer();
  download_file(serializer.serializeToString($('svg.svgcanvas')[0]),
    filename= document.title.split(' ').join('_') + '_' + type + '.svg',
    mimetype='image/svg+xml;charset=utf-8;');
}

function downloadPNG(type='graph') {
  var canvas = document.createElement("canvas");
  canvas.width = 3000;
  canvas.height = 3000;
  var ctx = canvas.getContext("2d");
  var serializer = new XMLSerializer();

  var svgurl = URL.createObjectURL(new Blob([serializer.serializeToString($('svg.svgcanvas')[0])],
    {type: "image/svg+xml;charset=utf-8"})); // <-- create a blob url for the svg image
  var img = new Image();
  img.onload = function() {
    // draw the svg to a canvas
    ctx.drawImage(img, 0, 0);
    URL.revokeObjectURL(svgurl);
    canvas.toBlob(function (blob) { // <-- convert the canvas to a png (in a blob)
      if (navigator.msSaveBlob) { // IE 10+
        navigator.msSaveBlob(blob, filename);
      } else {
        var link = document.createElement("a");
        if (link.download !== undefined) { // feature detection
          // Browsers that support HTML5 download attribute
          var url = URL.createObjectURL(blob);
          link.setAttribute("href", url);
          link.setAttribute("download", document.title.split(' ').join('_') + '_' + type + '.png');
          link.style.visibility = 'hidden';
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
          //make sure we revoke the object URL or else we use up memory
          //since we can't do it now, we have to make it happen later...
          window.setTimeout(function(){URL.revokeObjectURL(url);},30000); //30 seconds should do it.
        }
      }
    }, "image/png");
  };
  img.src = svgurl; // <-- load the blob url
}

// Because it is a context menu function, downloadSVG has to be bound to the document.
document.downloadSVG = downloadSVG;
document.downloadPNG = downloadPNG;

function download_file(data,filename='data.csv',mimetype='text/csv;charset=utf-8;') {
  //create a blob file, create a link, link the blob, click link, remove link
  var blob = new Blob([data], { type: mimetype });
  if (navigator.msSaveBlob) { // IE 10+
    navigator.msSaveBlob(blob, filename);
  } else {
    var link = document.createElement("a");
    if (link.download !== undefined) { // feature detection
      // Browsers that support HTML5 download attribute
      var url = URL.createObjectURL(blob);
      link.setAttribute("href", url);
      link.setAttribute("download", filename);
      link.style.visibility = 'hidden';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      //make sure we revoke the object URL or else we use up memory
      //since we can't do it now, we have to make it happen later...
      window.setTimeout(function(){URL.revokeObjectURL(url);},30000); //30 seconds should do it.
    }
  }
}

//Make this function available...
document.download_file = download_file;

function getStyleById(id) {
    return getAllStyles(document.getElementById(id));
}

function getAllStyles(elem) {
  if (!elem) return []; // Element does not exist, empty list.
  var win = document.defaultView || window, style, styleNode = [];
  var i;//to stop warnings
  if (win.getComputedStyle) { /* Modern browsers */
    style = win.getComputedStyle(elem, '');
    for (i=0; i<style.length; i++) {
      styleNode.push( style[i] + ':' + style.getPropertyValue(style[i]) );
      //               ^name ^           ^ value ^
    }
  } else if (elem.currentStyle) { /* IE */
    style = elem.currentStyle;
    for (var name in style) {
      styleNode.push( name + ':' + style[name] );
    }
  } else { /* Ancient browser..*/
    style = elem.style;
    for (i=0; i<style.length; i++) {
      styleNode.push( style[i] + ':' + style[style[i]] );
    }
  }
  return styleNode;
}

function radialPoint(x, y) {
  return [(y = +y) * Math.cos(x -= Math.PI / 2), y * Math.sin(x)];
}

function center_svg() {
  /*********************************************************************************************
   * In the case where this is being viewed in bl.ocks.org change the canvasdiv width/height to
   * match the containing span, which can only yield width/heigh reliably using jquery.
   */
  // find out if we are in an iframe.  If so, set the canvasdiv width/height to the iframe width/height.
  /*if(self !== top) {
    $('#canvasdiv').width($(window).width()).height($(window).height());
  }*/
  cdiv = $('div#canvasdiv');
  var svg = d3.select("svg"),
      width = +svg.attr("width"),
      height = +svg.attr("height");
  console.log({'svgwidth' : width, 'svgheight' : height, 'divwidth' : cdiv.width(), 'divheight' : cdiv.height() });
  cdiv.scrollLeft((width/2)-(cdiv.width()/2));
  cdiv.scrollTop((height/2)-(cdiv.height()/2));
}

function draw_radial(treeData) {
  var svg = d3.select("svg");
  // resize the svg based on calculated comment max_depth
  var width = document.comment_data.max_depth * 300;
  var height = width;
  svg.attr('width', width);
  svg.attr('height', height);
  var g = svg.append("g").attr("transform", "translate(" + (width / 2 + 40) + "," + (height / 2 + 90) + ")");
  var vote_scale = d3.scaleLinear(d3.schemePuOr)
    .domain(document.comment_data.quantiles)
    .range([0,50]);

  var tree = d3.tree()
      //.size([2 * Math.PI, 500])
      .size([2 * Math.PI, height/2])
      .separation(function(a, b) { return (a.parent == b.parent ? 1 : 2) / a.depth; });

  //set the width and height of canvasdiv to 80% of the current modal window size.
  //$('.canvasdiv').width($("#gmPopupContainer").width());
  //var height = $("#my_modal").height();
  //grab the root id and set the href of the jump-to-root link
  var root_id = treeData.id;
  var rootlink = document.getElementById('rootlink');
  rootlink.setAttribute("href", '#nodetext_' + root_id);
  $(rootlink).on('click',center_svg);
  var root = d3.hierarchy(treeData);
  tree(root);

  var link = g.selectAll(".link")
    .data(root.links())
    .enter().append("path")
      .attr("class", "link")
      .attr("d", d3.linkRadial()
          .angle(function(d) { return d.x; })
          .radius(function(d) { return d.y; })
      ).attr('fill', 'none');

  var node = g.selectAll(".node")
    .data(root.descendants())
    .enter().append("g")
      .attr("class", function(d) { return "node" + (d.children ? " node--internal" : " node--leaf"); })
      .attr("transform", function(d) {
        var rp = radialPoint(d.x, d.y);
        /*if(+svg.attr('width') < rp[1]+100) svg.attr('width', rp[1]+100);
        if(+svg.attr('height') < rp[0]+100) svg.attr('height', rp[0]+100);*/
        return "translate(" + rp + ")";
      });


  node.append("circle")
      .attr("r", 2.5);

  node.append("text")
      .attr("dy", "0.31em")
      .attr("x", function(d) { return d.x < Math.PI === !d.children ? 6 : -6; })
      .attr("text-anchor", function(d) { return d.x < Math.PI === !d.children ? "start" : "end"; })
      .attr("transform", function(d) { return "rotate(" + (d.x < Math.PI ? d.x - Math.PI / 2 : d.x + Math.PI / 2) * 180 / Math.PI + ")"; })
      .text(function(d) {
        return document.comment_data.comment_dict[d.data.id] ?
          document.comment_data.comment_dict[d.data.id].user :
          d.data.id;
      })
      .attr('id',function(d){return 'nodetext_'+d.data.id;}); //add an id to each nodetext for reference selection
  // show the canvas
  $('#rootlink').show();//show the rootlink
  $('.canvasdiv').show();
  //$('#rootlink').click();
  //$('#svgstyle').text('.svgcanvas {\n    ' + getStyleById('svgcanvas').join(';\n    ') + '\n}'+$('#svgstyle').text());
  /*var data = new XMLSerializer().serializeToString($('svg.svgcanvas')[0]);
  $('#testimg').on('load', function(){
    var canvas = document.createElement('canvas');
    // IE seems to not set width and height for svg in img tag...
    canvas.width = this.width||2000;
    canvas.height = this.height||2000;
    canvas.getContext('2d').drawImage(this, 0,0);
    $('.canvasdiv').appendChild(canvas);
  });
  $('#testimg').attr('src', 'data:image/svg+xml; charset=utf8, ' + encodeURIComponent(data));*/
  toggle_modal_size();
  center_svg();
}

function toggle_modal_size() {
  var a = $('exspana');
  a.text(a.text() == '[+]' ? '[-]' : '[+]');
  var popup = $("#gmPopupContainer");
  //save the current width/height
  popup.toggleClass('gmExpanded');
  popup.toggleClass('gmStandardModal');
  var pposition = popup.position();
  var cdiv = $('.canvasdiv');
  //var amount = 0.9; //90%
  cdiv.width(popup.width());
  cdiv.height((popup.height()-pposition.top));
}

//jquery hover event for later
/*
$("div input").hover(function() {
  $(this).addClass("blue");
}, function() {
  $(this).removeClass("blue");
});
*/

//transferrable object for web worker offloading of NLP
/*
//browser side...
var huge_array = new Float32Array(SIZE);
worker.postMessage(huge_array.buffer, [huge_array.buffer]); // new Trans Obj

//webworker side
self.onmessage = function(e) {
  var flt_arr = new Float32Array(e.data);
  //  typically you might want to populate flt_arr here
  //  now send data structure back to browser
  // self.postMessage(flt_arr.buffer);                    // old way
  self.postMessage(flt_arr.buffer, [flt_arr.buffer]); // new Trans Obj way
}
*/

//smooth scrolling on link
  /*rootlink.onclick(function() {
      if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
        var target = $(this.hash);
        target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
        if (target.length) {
          $('html,body').animate({
            scrollTop: target.offset().top
          }, 800);
          return false;
        }
      }
    });
  });*/
  //end rootlink code