require "std"

print "============================"

function getId(filename){
	var id = path.basename(filename).replace(Regexp(`/\..*$/`), "")
}

var assetsXml = "../data/xmls/game.xml"
var contens = File.readContents(assetsXml)

var beginMark = "<!-- begin auto generated assets -->"
var endMark = "<!-- end auto generated assets -->"

var m = Regexp("/^(\s*?)"..Regexp.escape(beginMark).."/m").exec(contens)
var indent = m[1].split("\n").last
// print {indent}; return;

var dir = fs.readdir("..\data_debug\images")
// print dir
var buf, count = Buffer(), 0
for(var _, filename in dir){
	if(Regexp(`/((tile|item|ent)-\d+(-\d+)?(-glow)?|(flame|explode)(-\d+)+)\.(png)/`).test(filename)){
		buf << "${indent}<image file=\"${filename}\" />\n"
		count++
	}
}

var re = Regexp("/"..Regexp.escape(beginMark)..".*"..Regexp.escape(endMark).."/s")

var stored = false
contens = contens.replace(re, function(){
	stored = true
	return "${beginMark}\n${buf}${indent}${endMark}"
})
if(!stored){
	throw "auto generated assets mark is not found in ${assetsXml}"
}

File.writeContents(assetsXml, contens)

print "${count} images updated"

