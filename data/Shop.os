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

Shop = extends Actor {
	pack = ItemsPack(),
	nextItemsUpdateTime = 0,
	openCount = 0,
	
	__construct = function(game, name){
		super()
		@name = name || "ent-043"
		@game = game
		@touchEnabled = false
		
		if(true || #@pack.items == 0 || @game.time > @nextItemsUpdateTime){
			@nextItemsUpdateTime = @game.time + math.random(1, 3) * 60
			@cols, @rows = 4, Backpack.rows
			@rows < 4 && math.random() < 0.3 && @rows++
			@pack.numSlots = @cols * @rows
			
			@pack.items = {
				{type = ITEM_TYPE_CANDY},
				{type = ITEM_TYPE_LADDERS},
			}
			var itemKeys = SHOP_ITEMS_INFO.keys
			var pickDamageItemFound = false
			while(#@pack.items < @pack.numSlots && #itemKeys > 0){
				var i = math.random(#itemKeys)
				var type = itemKeys[i]
				if(type != ITEM_TYPE_CANDY && type != ITEM_TYPE_LADDERS && type != ITEM_TYPE_SHOVEL){
					var isPickDamageItem = SHOP_ITEMS_INFO[type].pickDamage > 0
					if(!isPickDamageItem || !pickDamageItemFound){
						@pack.items[] = {type = type}
						pickDamageItemFound = pickDamageItemFound || isPickDamageItem
					}
				}
				delete itemKeys[i]
			}
		}
		if(!Backpack.hasPickItem()){
			@pack.items[0].type = ITEM_TYPE_SHOVEL
			if(#Backpack.pack.items == 0 && Player.bullets < ITEMS_INFO[ITEM_TYPE_SHOVEL].price){
				Player.bullets = ITEMS_INFO[ITEM_TYPE_SHOVEL].price
			}
		}
		
		/* @pack.items = {
			{type = 101}, 
			{type = 102}, 
			{type = 103}, 
			{type = 17}, 
			{type = 201}, 
			{type = 301}, 
			{type = 1}, 
			{type = 401}, 
			{type = 2}, 
			{type = 3}, 
			{type = 4}, 
		} */
		
		var bg = Box9Sprite().attrs {
			resAnim = res.get("panel"),
			// priority = 1,
			color = (Color.fromInt(0x77595a) * 2).clamp(),
			parent = this
		}
		bg.setGuides(20, 20, 20, 20)
		
		@title = PanelTitle(this, _T("Trader"))
		
		var borderSize = 10
		var paddingSize = 4
		
		@slots = []
		for(var x = 0; x < @cols; x++){
			for(var y = 0; y < @rows; y++){
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
		
		var trader = Box9Sprite().attrs {
			resAnim = res.get(@name),
			pivot = vec2(0, 0),
			pos = vec2(borderSize, borderSize),
			size = vec2(SLOT_SIZE, SLOT_SIZE),
			// scaleX = -1,
			parent = this,
		}
		
		@targetSlot = TargetSlot(@game, this).attrs {
			x = borderSize + (SLOT_SIZE + paddingSize) * 1,
			y = borderSize + (SLOT_SIZE + paddingSize) * 0,
			parent = this,
			touchChildrenEnabled = false,
			touchEnabled = false,
		}
		// @targetSlot.type = 101
		
		Sprite().attrs {
			resAnim = res.get("slot-arrow-right"),
			x = borderSize + (SLOT_SIZE + paddingSize) * 2 + SLOT_SIZE/2,
			y = borderSize + (SLOT_SIZE + paddingSize) * 0 + SLOT_SIZE/2,
			pivot = vec2(0.5, 0.5),
			parent = this,
			touchEnabled = false,
		}
		
		@buletsResAnim = res.get(@game.getSlotItemResName(ITEM_TYPE_BULLETS))
		@dest = Sprite().attrs {
			resAnim = @buletsResAnim,
			x = borderSize + (SLOT_SIZE + paddingSize) * 3 + SLOT_SIZE/2,
			y = borderSize + (SLOT_SIZE + paddingSize) * 0 + SLOT_SIZE/2,
			size = vec2(SLOT_SIZE, SLOT_SIZE),
			pivot = vec2(0.5, 0.5),
			parent = this,
			opacity = 0.5,
			touchEnabled = false,
		}
		@destCountText = TextField().attrs {
			resFont = res.get("test"),
			vAlign = TEXT_VALIGN_BOTTOM,
			hAlign = TEXT_HALIGN_RIGHT,
			// text = "abc",
			pos = @dest.pos + @dest.size/2 - vec2(4, 5),
			// priority = 2,
			parent = this,
		}
		
		@backpack = Backpack(@game).attrs {
			// pivot = vec2(0, 0),
			x = @width + borderSize,
			parent = this,
		}
		@width = @backpack.x + @backpack.width
		@height = math.max(@height, @backpack.height)
		/*
		var backpack = Backpack(@game).attrs {
			pivot = vec2(0, 1),
			pos = @size + vec2(borderSize, 0),
			parent = this,
		}
		@width = backpack.x + backpack.width
		*/
		
		@updateItems()
		
		@addTimeout(1.5, @startTutorial.bind(this))
	},
	
	startTutorial = function(){
		if(!GAME_SETTINGS.doneTutorials.sellItem){
			var sellItems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
			for(var slotNum, item in @backpack.pack.items.reverseIter()){
				if(item.type in sellItems){
					// GAME_SETTINGS.doneTutorials.sellItem = true
					var startBullets = Player.bullets
					var pos = @backpack.slots[slotNum].pos + vec2(SLOT_SIZE/2, SLOT_SIZE/2)
					var finger = HandFinger().attrs {
						pos = @backpack.slots[slotNum].parent.localToLocal(pos, this),
						parent = this,
					}
					var checkUpdateHandle = finger.addUpdate(0.2, function(){
						if(startBullets != Player.bullets){
							GAME_SETTINGS.doneTutorials.sellItem = true
							saveGameSettings()
							
							finger.detach()
							// finger.removeUpdate(checkUpdateHandle)
							// finger.removeActions()
						}
					})
					var startPos, startAngle = finger.pos, 10
					var endPos = @targetSlot.pos + vec2(SLOT_SIZE/2, SLOT_SIZE/2)
					var endAngle = 0
					var animateTutorial = function(){
						finger.pos = startPos
						finger.angle = startAngle
						finger.opacity = 0
						finger.replaceTweenAction {
							name = "tutorial",
							duration = 0.4,
							opacity = 1,
							doneCallback = function(){
								finger.animateTouch(function(){
									finger.replaceTweenAction {
										name = "tutorial",
										duration = 2,
										pos = endPos,
										angle = endAngle,
										ease = Ease.CUBIC_IN_OUT,
										doneCallback = function(){
											finger.animateUntouch(function(){
												finger.addTimeout(0.5, function(){
													finger.replaceTweenAction {
														name = "tutorial",
														duration = 0.3,
														opacity = 0,
														doneCallback = function(){
															finger.addTimeout(1, animateTutorial)
														},
													}
												})
											})
										},
									}
								})
							},
						}
					}
					animateTutorial()
					return
				}
			}
		}
	
	},
	
	updateItems = function(){
		@pack.updateActorItems(this)
	},
	
	getSellPriceByType = function(type){
		var sellScale = ITEMS_INFO[type].canBuy !== false ? 0.95  : 1
		return math.ceil(ITEMS_INFO[type].price * sellScale)
	},
	
	resetTargetSlot = function(){
		@targetSlot.isTarget = true
		@targetSlot.type = ITEM_TYPE_EMPTY
		@targetSlot.count = null
		@dest.resAnim = @buletsResAnim
		@dest.opacity = 0.5
		@destCountText.text = ""
	},
	
	showSell = function(slot){
		slot.type || return;
		@targetSlot.isTarget = true
		@targetSlot.type = slot.type
		@targetSlot.count = slot.count
		@targetSlot.sprite.opacity = 0.5
		@dest.resAnim = @buletsResAnim
		@dest.opacity = 0.5
		@destCountText.text = @getSellPriceByType(slot.type) * slot.count
	},
	
	endShowSell = function(){
		@targetSlot.sprite.opacity = 1
	},
	
	showBuy = function(slot){
		slot.type || return;
		@targetSlot.isTarget = false
		@targetSlot.type = ITEM_TYPE_BULLETS
		@targetSlot.count = ITEMS_INFO[slot.type].price
		@targetSlot.sprite.opacity = 0.5
		@dest.resAnim = res.get(@game.getSlotItemResName(slot.type))
		@dest.opacity = 1
		@destCountText.text = ""
	},
}