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

logoEnabled = true

lang = "ru"
langStrings = require("langs/${lang}/strings.os", false)

baseLang = "en"
baseLangStrings = require("langs/${baseLang}/strings.os", false)

function _T(text){
	return langStrings[text] || baseLangStrings[text] || text
}

GAME_SETTINGS = {
	sound = true,
	music = true,
	// bullets = 0,
	doneTutorials = {
		// sellItem = false,
	},
	saveSlots = {
		/* 1 = {
			levelNum = 1,
			date = DateTime.now(),
		}, */
	},
}

var gameSettingsFilename = "settings.json"

function loadGameSettings(){
	File.exists(gameSettingsFilename) || return;
	var settings = json.decode(File.readContents(gameSettingsFilename))
	
	GAME_SETTINGS.sound = settings.sound === null ? true : !!settings.sound
	GAME_SETTINGS.music = settings.music === null ? true : !!settings.music
	
	GAME_SETTINGS.doneTutorials = {}
	for(var key, value in settings.doneTutorials){
		GAME_SETTINGS.doneTutorials[key] = !!value
	}
	
	GAME_SETTINGS.saveSlots = {}
	for(var saveSlotNum, saveSlot in settings.saveSlots){
		var date, time = saveSlot.date.split(" ").unpack()
		// print(date, time)
		var year, month, day = date.split("-").unpack()
		var hour, minute, seconds = time.split(":").unpack()
		// print(year, month, day, hour, minute, seconds)
		GAME_SETTINGS.saveSlots[saveSlotNum] = {
			levelNum = toNumber(saveSlot.levelNum),
			xor = toNumber(saveSlot.xor),
			date = DateTime(year, month, day, hour, minute, seconds),
		}
	}
	// Player.bullets = math.max(0, toNumber(GAME_SETTINGS.bullets))
}

function saveGameSettings(){
	// GAME_SETTINGS.bullets = Player.bullets
	var data = json.encode(GAME_SETTINGS)
	File.writeContents(gameSettingsFilename, data)
}

loadGameSettings()
print "GAME_SETTINGS: ${GAME_SETTINGS}"

function playMenuClickSound(){
	splayer.play {
		sound = "menu-click",
	}
}

var errSound = null
function playErrClickSound(){
	if(!errSound){
		errSound = splayer.play {
			sound = "unavailable",
		}
		errSound.doneCallback = function(){
			errSound = null
		}
	}
}

var moneySound = null
function playMoneySound(){
	if(!moneySound){
		var name = sprintf("coins-%02d", math.round(math.random(1, 1)))
		moneySound = splayer.play {
			sound = name,
		}
		moneySound.doneCallback = function(){
			moneySound = null
		}
	}
}

var music, musicTimeout = null
function playMusic(name, volume){
	var delay = 0.01
	if(music){
		music.fadeOut(2)
		delay = 2.01
	}
	stage.removeTimeout(musicTimeout)
	musicTimeout = stage.addTimeout(delay, function(){
		musicTimeout = null
		music = mplayer.play {
			sound = name,
			looping = true,
			fadeIn = 1,
			volume = volume || 0.5,
		}
	})
}

// splayer.resources.get("menu-click")

Logo()
// Game4X().parent = stage

