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

NPC_Trader = extends NPC {
	__construct = function(game, type){
		super(game, type, "trader")
		@thinkTime = 0
		@tutorial = null
	},
	
	cleanup = function(){
		@tutorial.detach()
		@tutorial = null
		super()
	},
	
	runTutorial = function(target){
		@tutorial || @checkTutorial(target)
	},
	
	checkTutorial = function(target){
		@tutorial && throw "tutorial is already started"
		target || target = @game.speechBubbles
		if(!GAME_SETTINGS.doneTutorials.touchTrader){
			@tutorial = Tutorial.animateTouchEntity {
				target = target,
				ent = this,
				updateCallback = function(){
					var dx = math.abs(@tileX - @game.player.tileX)
					var dy = math.abs(@tileY - @game.player.tileY)
					if(dx > 3 || dy > 1 || GAME_SETTINGS.doneTutorials.touchTrader){
						@tutorial.detach()
						@tutorial = null
						// @runTutorial(target)
					}
				},
			}
		}
	},
	
	thinkAboutPlayer = function(){
		if(!Player.pickItemType){
			@game.bubbleItem(this, @game.player.tileX, @game.player.tileY, ITEM_TYPE_SHOVEL)
		}else if(@game.time - @thinkTime > 2){
			@thinkTime = @game.time
			if(math.random() < 0.2){
				@game.bubbleItem(this, @game.player.tileX, @game.player.tileY, randItem(SHOP_ITEMS_INFO.keys))
			}
		}
	},
	
	checkMoveDir = function(){
		super()
		if(!GAME_SETTINGS.doneTutorials.touchTrader){
			if(!@moving && !@moveAnimatedX && !@moveAnimatedY && !@tutorial && !Player.pickItemType){
				var dx = math.abs(@tileX - @game.player.tileX)
				var dy = math.abs(@tileY - @game.player.tileY)
				dx <= 3 && dy <= 1 && @runTutorial()
			}
			if(@tutorial){
				@moveDir.x = @moveDir.y = 0
			}
		}
	},
	
	onClick = function(ev){
		@game.openShop(this)
	},	
}