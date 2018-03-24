// ==UserScript==
// @name        
// @namespace   
// @description 
// @include     
// @version     0.0.1
// @grant       GM_addStyle
// @require     https://code.jquery.com/jquery-3.2.1.slim.min.js
// @require     https://d3js.org/d3.v4.min.js
// ==/UserScript==
/*jshint esversion: 6 */
/*vi: ft=javascript ts=2 sw=2 sts=2 et*/
/*NOTE: Do not touch above this line*/
function download_text_file(textData,filename='data.csv',mimetype='text/csv;charset=utf-8;') {
  //create a blob file, create a link, link the blob, click link, remove link
  var blob = new Blob([textData], { type: mimetype });
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
      window.setTimeout(function(){URL.revokeObjectURL(blob);},30000); //30 seconds should do it.
      URL.revokeObjectURL(blob);
    }
  }
}

//Make this function available...
document.download_text_file = download_text_file;
document.userscript_data = {
  init_data : function() {
  },
  clear_data : function() {
    $.each(this, function(k,v){
      switch(typeof this[k]) {
        case 'string':
          this[k] = '';
          break;
        case 'object':
          this[k] = {};
          break;
        case 'number':
          this[k] = 0;
          break;
        default:
          this[k] = undefined;
      }});
  },
};
$(document).ready(function() {
  $("body").append ( `
  <!-- Add HTML here -->
  ` );
  //--- CSS styles make it work...
  GM_addStyle ( `
  /* Add styles here */
  `);
});
