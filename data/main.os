/******************************************************************************
* Copyright (C) 2014 Evgeniy Golovin (evgeniy.golovin@unitpoint.ru)
*
* Please feel free to contact me at anytime, 
* my email is evgeniy.golovin@unitpoint.ru, skype: egolovin
*
* eXeXeXeX is a 4X genre of strategy-based video game in which player 
* "eXplore, eXpand, eXploit, and eXterminate" the world
* 
* Latest source code
*	eXeXeXeX: https://github.com/unitpoint/eXeXeXeX
* 	OS2D engine: https://github.com/unitpoint/os2d
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
******************************************************************************/

print "--"
print "[start] ${DateTime.now()}"

require "utils"

GAME_SIZE = vec2(960, 540)

var displaySize = stage.size
var scale = displaySize / GAME_SIZE
// scale = math.max(scale.x, scale.y)
scale = math.min(scale.x, scale.y)
stage.size = (displaySize / scale).round()
stage.scale = displaySize / stage.size // scale

logoEnabled = false
lang = "ru"
langStrings = require("langs/${lang}/strings.os", false)

function _T(text){
	return langStrings[text] || text
}

GAME_SETTINGS = {
	sound = true,
	music = true,
	doneTutorials = {
		// sellItem = false,
	},
	saveSlots = {
	
	},
}

var gameSettingsFilename = "settings.json"

function loadGameSettings(){
	GAME_SETTINGS = File.exists(gameSettingsFilename) && json.decode(File.readContents(gameSettingsFilename))
	// print "loaded GAME_SETTINGS: ${GAME_SETTINGS}"
	typeOf(GAME_SETTINGS) == "object" || GAME_SETTINGS = {}
	GAME_SETTINGS.sound === null && GAME_SETTINGS.sound = true
	GAME_SETTINGS.music === null && GAME_SETTINGS.music = true
	typeOf(GAME_SETTINGS.doneTutorials) == "object" || GAME_SETTINGS.doneTutorials = {}
	typeOf(GAME_SETTINGS.saveSlots) == "object" || GAME_SETTINGS.saveSlots = {}
}

function saveGameSettings(){
	var data = json.encode(GAME_SETTINGS)
	File.writeContents(gameSettingsFilename, data)
}

loadGameSettings()
// print "GAME_SETTINGS: ${GAME_SETTINGS}"

if(false)
mplayer.play { 
	sound = "music",
	looping = true,
	volume = 0.3,
}

Logo()
// Game4X().parent = stage

