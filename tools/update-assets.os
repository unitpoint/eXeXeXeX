require "std"
require "../data/consts"

print "============================"

function getId(filename){
	var id = path.basename(filename).replace(Regexp(`/\..*$/`), "")
}

var srcFilename = "../data/resElements.os"
var assetsXml = "../data/xmls/game.xml"
var contens = File.readContents(assetsXml)

var beginMark = "<!-- begin auto generated assets -->"
var endMark = "<!-- end auto generated assets -->"

var m = Regexp("/^(\s*?)"..Regexp.escape(beginMark).."/m").exec(contens)
var indent = m[1].split("\n").last
// print {indent}; return;

var resBuf, imageCount = Buffer(), 0
var dir = fs.readdir("../data_debug/images")
// print dir
for(var _, filename in dir){
	// if(Regexp(`/((tile|item|ent)-\d+(-\d+)?(-glow)?|(flame|explode)(-\d+)+)\.(png|jpg)/`).test(filename)){
	if(Regexp(`/(flame|explode)(-\d+)\.png/`).test(filename)){
		resBuf << "${indent}<image file=\"${filename}\" />\n"
		imageCount++
	}
}

function num(s){
	return toNumber(s.replace(Regexp(`/^0+/s`), ''))
}

var elements = {}

var tileCount = 0
var dir = fs.readdir("../data_debug/images/tiles")
// print dir
for(var _, filename in dir){
	var m = Regexp(`/^tile-(\d+)x(\d+)-(\d+)(-(\d+))?(-glowing)?\.(png|jpg)$/s`).exec(filename)
	// print "${filename}, ${m}"
	m || throw "error element filename 'tiles/${filename}'"
	var cols, rows = num(m[1]) / TILE_SIZE, num(m[2]) / TILE_SIZE
	var type, variants, glowing = num(m[3]), !!m[5], !!m[6]
	type > 0 || throw "error type in 'tiles/${filename}', m: ${m}"
	if(elements[type]){
		var elem = elements[type]
		elem.cols == cols || throw "mismatch cols in 'tiles/${filename}', new: ${cols}, cur: ${elem.cols}, elem: ${elem}, m: ${m}"
		elem.rows == rows || throw "mismatch rows in 'tiles/${filename}', new: ${rows}, cur: ${elem.rows}, elem: ${elem}, m: ${m}"
		// elem.glowing == glowing || throw "mismatch cols in 'tiles/${filename}', new: ${glowing}, cur: ${elem.glowing}, elem: ${elem}, m: ${m}"
		!!elem.variants == !!variants || throw "mismatch cols in 'tiles/${filename}', new: ${variants}, cur: ${elem.variants}, elem: ${elem}, m: ${m}"
		glowing && elem.glowing = true
		variants && elem.variants[] = getId(filename) // math.max(elem.variants, variants)
	}else{
		elements[type] = {
			type = type,
			res = variants ? null : getId(filename),
			variants = variants ? [getId(filename)] : null,
			isTile = true,
			cols = cols,
			rows = rows,
			glowing = glowing,
			
		}
	}
	resBuf << "${indent}<image file=\"tiles/${filename}\" cols=\"${cols}\" rows=\"${rows}\" />\n"
	tileCount++
}

var itemCount = 0
var dir = fs.readdir("../data_debug/images/items")
// print dir
for(var _, filename in dir){
	var m = Regexp(`/^item-(\d+)x(\d+)-(\d+)(-glowing)?\.(png|jpg)$/s`).exec(filename)
	// print "${filename}, ${m}"
	m || throw "error element filename 'items/${filename}'"
	var cols, rows = num(m[1]) / TILE_SIZE, num(m[2]) / TILE_SIZE
	var type, glowing = num(m[3]), !!m[4]
	type > 0 || throw "error type in 'items/${filename}', m: ${m}"
	if(elements[type]){
		var elem = elements[type]
		elem.isItem || throw "mismatch isItem in 'items/${filename}', cur: ${elem.isItem}, elem: ${elem}, m: ${m}"
		elem.cols == cols || throw "mismatch cols in 'items/${filename}', new: ${cols}, cur: ${elem.cols}, elem: ${elem}, m: ${m}"
		elem.rows == rows || throw "mismatch rows in 'items/${filename}', new: ${rows}, cur: ${elem.rows}, elem: ${elem}, m: ${m}"
		// elem.glowing == glowing || throw "mismatch cols in 'items/${filename}', new: ${glowing}, cur: ${elem.glowing}, elem: ${elem}, m: ${m}"
		glowing && elem.glowing = true
	}else{
		elements[type] = {
			type = type,
			res = getId(filename),
			isItem = true,
			cols = cols,
			rows = rows,
			glowing = glowing,
			
		}
	}
	resBuf << "${indent}<image file=\"items/${filename}\" />\n"
	itemCount++
}

var entCount = 0
var dir = fs.readdir("../data_debug/images/entities")
// print dir
for(var _, filename in dir){
	var m = Regexp(`/^ent-(\d+)x(\d+)-(\d+)(-glowing)?\.png$/s`).exec(filename)
	// print "${filename}, ${m}"
	m || throw "error element filename 'entities/${filename}'"
	var width, height = num(m[1]), num(m[2])
	var type, glowing = num(m[3]), !!m[4]
	type > 0 || throw "error type in 'entities/${filename}', m: ${m}"
	if(elements[type]){
		var elem = elements[type]
		elem.isEntity || throw "mismatch isEntity in 'entities/${filename}', cur: ${elem.isItem}, elem: ${elem}, m: ${m}"
		elem.width == width || throw "mismatch width in 'entities/${filename}', new: ${width}, cur: ${elem.width}, elem: ${elem}, m: ${m}"
		elem.height == height || throw "mismatch height in 'entities/${filename}', new: ${height}, cur: ${elem.height}, elem: ${elem}, m: ${m}"
		// elem.glowing == glowing || throw "mismatch cols in 'entities/${filename}', new: ${glowing}, cur: ${elem.glowing}, elem: ${elem}, m: ${m}"
		glowing && elem.glowing = true
	}else{
		elements[type] = {
			type = type,
			res = getId(filename),
			isEntity = true,
			width = width,
			height = height,
			glowing = glowing,
			
		}
	}
	resBuf << "${indent}<image file=\"entities/${filename}\" />\n"
	entCount++
}

for(var type, elem in elements){
	if(!elem.res) delete elem.res
	if(!elem.variants) delete elem.variants
	if(!elem.glowing) delete elem.glowing
	if(elem.cols == 1 && elem.rows == 1){
		delete elem.cols
		delete elem.rows
	}
}

var re = Regexp("/"..Regexp.escape(beginMark)..".*"..Regexp.escape(endMark).."/s")

var stored = false
contens = contens.replace(re, function(){
	stored = true
	return "${beginMark}\n${resBuf}${indent}${endMark}"
})
if(!stored){
	throw "auto generated assets mark is not found in ${assetsXml}"
}

File.writeContents(assetsXml, contens)
File.writeContents(srcFilename, <<<END"
/* auto generated file */
return ${json.encode(elements)}
END)

print "${imageCount} images, ${tileCount} tiles, ${itemCount} items, ${entCount} entities updated"

