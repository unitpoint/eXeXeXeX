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
		@tutorial = null
		
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
		
		var borderSize, paddingSize = 10, 4
		
		@backpack = Backpack(@game).attrs {
			// pivot = vec2(0, 0),
			// x = @width + borderSize,
			parent = this,
		}
		
		var bg = Box9Sprite().attrs {
			resAnim = res.get("panel"),
			// priority = 1,
			color = (Color.fromInt(0x77595a) * 2).clamp(),
			x = @backpack.x + @backpack.width + borderSize,
			parent = this
		}
		bg.setGuides(20, 20, 20, 20)
		
		@slots = []
		for(var x = 0; x < @cols; x++){
			for(var y = 0; y < @rows; y++){
				var slot = ItemSlot(@game, this, #@slots).attrs {
					x = borderSize + (SLOT_SIZE + paddingSize) * x,
					y = borderSize + (SLOT_SIZE + paddingSize) * (y + 1),
					parent = bg,
				}
				@slots[] = slot
			}
		}
		bg.width = slot.x + slot.width + borderSize
		bg.height = slot.y + slot.height + borderSize
		
		@title = PanelTitle(bg, _T("Trader"), bg.color) // Color(0.99, 0.99, 0.7))
		@title.x = bg.width - @title.width
		
		@width = bg.x + bg.width
		@height = math.max(bg.height, @backpack.height)
		
		var trader = Box9Sprite().attrs {
			resAnim = res.get(@name),
			x = borderSize + (SLOT_SIZE + paddingSize) * 3,
			y = borderSize + (SLOT_SIZE + paddingSize) * 0,
			size = vec2(SLOT_SIZE, SLOT_SIZE),
			// scaleX = -1,
			parent = bg,
		}
		
		@targetSlot = TargetSlot(@game, this).attrs {
			x = borderSize + (SLOT_SIZE + paddingSize) * 2,
			y = borderSize + (SLOT_SIZE + paddingSize) * 0,
			parent = bg,
			touchChildrenEnabled = false,
			touchEnabled = false,
		}
		// @targetSlot.type = 101
		
		Sprite().attrs {
			resAnim = res.get("slot-arrow-left"),
			x = borderSize + (SLOT_SIZE + paddingSize) * 1 + SLOT_SIZE/2,
			y = borderSize + (SLOT_SIZE + paddingSize) * 0 + SLOT_SIZE/2,
			pivot = vec2(0.5, 0.5),
			parent = bg,
			touchEnabled = false,
		}
		
		@buletsResAnim = res.get(@game.getSlotItemResName(ITEM_TYPE_BULLETS))
		@dest = Sprite().attrs {
			resAnim = @buletsResAnim,
			x = borderSize + (SLOT_SIZE + paddingSize) * 0 + SLOT_SIZE/2,
			y = borderSize + (SLOT_SIZE + paddingSize) * 0 + SLOT_SIZE/2,
			size = vec2(SLOT_SIZE, SLOT_SIZE),
			pivot = vec2(0.5, 0.5),
			parent = bg,
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
			parent = bg,
		}
		
		@updateItems()
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
		target || target = stage
		var allDone = true
		if(!GAME_SETTINGS.doneTutorials.sellItem){
			// if(Player.bullets < ITEMS_INFO[ITEM_TYPE_SHOVEL].price){
				var sellItems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
				for(var slotNum, item in @backpack.pack.items){
					if(item.type in sellItems && ITEMS_INFO[item.type].price >= ITEMS_INFO[ITEM_TYPE_SHOVEL].price){
						@tutorial = Tutorial.animateDragFinger {
							target = target,
							startPos = @backpack.slots[slotNum].localToLocal(vec2(SLOT_SIZE/2, SLOT_SIZE/2), target),
							endPos = @targetSlot.localToLocal(vec2(SLOT_SIZE/2, SLOT_SIZE/2), target),
							startAngle = 0,
							endAngle = 10,
							updateCallback = function(){
								if(Player.bullets >= ITEMS_INFO[ITEM_TYPE_SHOVEL].price){
									GAME_SETTINGS.doneTutorials.sellItem = true
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
			// }
			allDone = false
		}
		if(!GAME_SETTINGS.doneTutorials.buyItem){
			if(!Backpack.hasPickItem() && @slots[0].type == ITEM_TYPE_SHOVEL 
				&& Player.bullets >= ITEMS_INFO[ITEM_TYPE_SHOVEL].price)
			{
				var emptySlotNum
				for(var i = 0; i < Backpack.pack.numSlots; i++){
					if(!Backpack.pack.items[i]){
						emptySlotNum = i
						break
					}
				}
				if(emptySlotNum){
					// var startBullets = Player.bullets
					@tutorial = Tutorial.animateDragFinger {
						target = target,
						startPos = @slots[0].localToLocal(vec2(SLOT_SIZE/2, SLOT_SIZE/2), target),
						endPos = @backpack.slots[emptySlotNum].localToLocal(vec2(SLOT_SIZE/2, SLOT_SIZE/2), target),
						startAngle = 10,
						endAngle = 0,
						updateCallback = function(){
							if(Backpack.hasPickItem()){
								GAME_SETTINGS.doneTutorials.buyItem = true
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
			allDone = false
		}
		if(!allDone){
			@runTutorial(target)
		}else{
			@backpack.runTutorial(target)
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
		@targetSlot.countText.color = Color.WHITE
		@targetSlot.sprite.opacity = 0.5
		@dest.resAnim = @buletsResAnim
		@dest.opacity = 0.5
		@destCountText.text = @getSellPriceByType(slot.type) * slot.count
	},
	
	endShowSell = function(){
		@targetSlot.sprite.opacity = 1
	},
	
	showBuy = function(slot, count, color){
		slot.type || return;
		@targetSlot.isTarget = false
		@targetSlot.type = ITEM_TYPE_BULLETS
		@targetSlot.count = ITEMS_INFO[slot.type].price * (count || 1)
		color && @targetSlot.countText.color = color // Color.WHITE
		@targetSlot.sprite.opacity = 1
		@dest.resAnim = res.get(@game.getSlotItemResName(slot.type))
		@dest.opacity = 1
		@destCountText.text = ""
	},
	
	/* updateBuyText = function(slot, count, color){
		slot.type || throw "empty slot type"
		@targetSlot.count = ITEMS_INFO[slot.type].price * count
		color && @targetSlot.countText.color = color
	}, */
}