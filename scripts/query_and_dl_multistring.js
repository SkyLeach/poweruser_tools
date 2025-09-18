// query elements to build a text file and download that file.
l = $("a.text-plain");
console.log(l);
multistring='';
for(const key in l) {
	try{
		multistring+=l[key].attributes.href.value+'\n';
		console.log(multistring);
	}catch(se){}
}

function save(data) {
  var c = document.createElement("a");
  c.download = "user-text.txt";
  var t = new Blob([data], {
    type: "text/plain"});
  c.href = window.URL.createObjectURL(t);
  c.click();
}

save(multistring);
