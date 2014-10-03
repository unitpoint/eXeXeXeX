require "std"


var contents = File.readContents("c:\Users\craft\Downloads\decoded-image[object HTMLDivElement]")
var data = zlib.gzuncompress(contents)
print "len: "..#data