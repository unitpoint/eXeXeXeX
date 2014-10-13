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

Backpack = extends Actor {
	pack = null,
	cols = null,
	rows = null,
	
	__construct = function(game){
		super()
		@game = game
		@name  = "backpack"
		@tutorial = null
		
		/* @pack.items = {
			{type = 101, count = 7}, 
			{type = 102, count = 2}, 
			{type = 103, count = 4}, 
			{type = 17, count = 34}, 
			{type = 201, count = 1}, 
			{type = 301, count = 3}, 
			{type = 1, count = 1}, 
			{type = 401, count = 2}, 
			{type = 2, count = 1}, 
			{type = 3, count = 1}, 
			{type = 4, count = 1}, 
		} */
		
		var bg = Box9Sprite().attrs {
			resAnim = res.get("panel"),
			// priority = 1,
			parent = this
		}
		bg.setGuides(20, 20, 20, 20)
		
		@title = PanelTitle(this, _T("Backpack"))
		
		var borderSize = 10
		var paddingSize = 4
		
		@slots = []
		for(var x = 0; x < @cols; x++){
			for(var y = 0; y < @rows; y++){
				// x == 0 && y == 0 && continue
				var slot = ItemSlot(@game, this, #@slots).attrs {
					x = borderSize + (SLOT_SIZE + paddingSize) * x,
					y = borderSize + (SLOT_SIZE + paddingSize) * (y + 1),
					parent = this,
				}
				@slots[] = slot
			}
		}
		@width = slot.x + slot.width + borderSize
		@height = slot.y + slot.height + borderSize
		bg.size = @size
		
		var icon = Box9Sprite().attrs {
			resAnim = res.get("backpack"),
			pivot = vec2(0, 0),
			pos = vec2(borderSize, borderSize),
			size = vec2(SLOT_SIZE, SLOT_SIZE),
			// scaleX = -1,
			parent = this,
		}
		
		@bulletsSprite = Sprite().attrs {
			resAnim = res.get(@game.getSlotItemResName(ITEM_TYPE_BULLETS)),
			x = borderSize + (SLOT_SIZE + paddingSize) * (@cols - 1) + SLOT_SIZE/2,
			y = borderSize + (SLOT_SIZE + paddingSize) * 0 + SLOT_SIZE/2,
			size = vec2(SLOT_SIZE, SLOT_SIZE),
			pivot = vec2(0.5, 0.5),
			parent = this,
			opacity = 0.5,
			touchEnabled = false,
		}
		@bulletsCount = []
		@bulletsCount[] = TextField().attrs {
			resFont = res.get("test_2"),
			vAlign = TEXT_VALIGN_BOTTOM,
			hAlign = TEXT_HALIGN_RIGHT,
			text = @_bullets = Player.bullets,
			pos = @bulletsSprite.pos + @bulletsSprite.size/2 - vec2(4, 5),
			color = Color.fromInt(0xf9a288),
			priority = 1,
			parent = this,
		}
		var cloneText = function(delta, color){
			var originText = @bulletsCount.first
			var text = TextField().attrs {
				resFont = originText.resFont,
				vAlign = originText.vAlign,
				hAlign = originText.hAlign,
				text = originText.text,
				pos = originText.pos + delta,
				// priority = 0,
				color = color || Color.WHITE,
				opacity = 0.5,
				parent = this,
			}
			@bulletsCount[] = text
		}
		
		var color = Color.fromInt(0x391a05)
		for(var x = -1; x < 2; x+=2){
			for(var y = -1; y < 2; y+=2){
				cloneText(vec2(x, y), color)
			}
		}
		
		@countBulletsUpdateHandle = null
		
		@updateItems()
	},
	
	__set@bullets = function(value){
		@_bullets == value && return;
		@_bullets = value
		for(var _, item in @bulletsCount){
			item.text = value
		}
	},
	
	updateBullets = function(){
		@_bullets == Player.bullets && return;
		var scaleAction = RepeatForeverAction(TweenAction {
			duration = 0.2,
			scale = {from = 1, to = 1.1},
			ease = Ease.PING_PONG,
		})
		scaleAction.name = "countBullets"
		@bulletsSprite.replaceAction(scaleAction)
		
		var startBullets = @_bullets
		var delta = Player.bullets - startBullets
		if(delta > 0) --delta else if(delta < 0) ++delta
		
		var time = math.max(3.0, math.min(0.05, math.abs(delta / 500)))
		var accum = 0
		
		@removeUpdate(@countBulletsUpdateHandle)
		@countBulletsUpdateHandle = @addUpdate(0.05, function(ev){
			accum += ev.dt
			if(accum >= time){
				@removeUpdate(@countBulletsUpdateHandle)
				@countBulletsUpdateHandle = null
				@bulletsSprite.removeAction(scaleAction)
				@bulletsSprite.scale = 1
				@bullets = Player.bullets
			}else{
				var t = Ease.run(accum / time, Ease.CUBIC_OUT)
				@bullets = math.round(startBullets + delta * t)
			}
		})
	},
	
	updateItems = function(){
		@pack.updateActorItems(this)
		@game.updateHudItems()
	},
	
	addItem = function(type, count){
		if(type == ITEM_TYPE_BULLETS){
			Player.bullets += (count || 1) * 200
			return true
		}
		return @pack.addItem(type, count)
	},
	
	hasItem = function(type){
		return @pack.hasItem(type)
	},
	
	hasPickItem = function(){
		for(var type in PICK_DAMAGE_ITEMS_INFO){
			@hasItem(type) && return true
		}
	},
	
	initPack = function(){
		@cols, @rows = 3, 2
		@pack = ItemsPack(@cols * @rows)
		
		for(var i, type in [1, 3, 6]){
		// for(var i, type in [1, 3, 11, 13]){
			@pack.items[i] = {type = type, count = 1}
		}
		
		/* for(var type, item in ITEMS_INFO){
			if(item.canBuy === false){
				
			}
		} */
	},
	
	cleanup = function(){
		@tutorial.detach()
		@tutorial = null
	},
	
	runTutorial = function(target){
		@addTimeout(1.5, function(){
			@checkTutorial(target)
		})
	},
	
	checkTutorial = function(target){
		target || target = @game
		var allDone = true
		if(!GAME_SETTINGS.doneTutorials.setPickItem){
			if(Player.pickItemType){
				GAME_SETTINGS.doneTutorials.setPickItem = true
				saveGameSettings()
				@addTimeout(1.5, function(){
					@checkTutorial(target)
				})
			}else if(Backpack.hasPickItem()){
				for(var _, destSlot in @game.hudSlots){
					if(destSlot.isEmpty){
						for(var _, srcSlot in @slots){
							if(srcSlot.type in PICK_DAMAGE_ITEMS_INFO){
								@tutorial = Tutorial.animateDragFinger {
									target = target,
									startPos = srcSlot.localToLocal(vec2(SLOT_SIZE/2, SLOT_SIZE/2), target),
									endPos = destSlot.localToLocal(vec2(SLOT_SIZE/2, SLOT_SIZE/2), target),
									startAngle = 0,
									endAngle = 10,
									updateCallback = function(){
										if(Player.pickItemType){
											GAME_SETTINGS.doneTutorials.setPickItem = true
											saveGameSettings()
											@tutorial.detach()
											@tutorial = null
											@runTutorial(target)
										}
									},
								}
								return
							}
						}
					}
				}
			}
			allDone = false
		}
		if(!allDone){
			@runTutorial(target)
		}else{
			/* @addTimeout(1.5, function(){
				@backpack.checkTutorial()
			}) */
		}
	},
}

Backpack.initPack()
