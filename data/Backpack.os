Backpack = extends Actor {
	items = {
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
	},
	numItemsByType = {
	},
	
	__construct = function(game){
		super()
		@game = game
		
		@cols = 2
		@rows = 3
		
		var bg = Box9Sprite().attrs {
			resAnim = res.get("panel"),
			// priority = 1,
			parent = this
		}
		bg.setGuides(20, 20, 20, 20)
		
		var borderSize = 10
		var paddingSize = 4
		
		@slots = []
		for(var x = 0; x < @cols; x++){
			for(var y = 0; y < @rows; y++){
				x == 0 && y == 0 && continue
				var slot = ItemSlot().attrs {
					name = "backpackSlot",
					// resAnim = res.get("slot"),
					x = borderSize + (SLOT_SIZE + paddingSize) * x,
					y = borderSize + (SLOT_SIZE + paddingSize) * y,
					parent = this,
					slotNum = #@slots,
					touchChildrenEnabled = false,
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
		/*
		var backpack = Sprite().attrs {
			resAnim = res.get("backpack"),
			pivot = vec2(0.2, 0.8),
			x = @width,
			y = @height,
			// scaleX = -1,
			parent = this,
		}
		
		@text = TextField().attrs {
			resFont = res.get("test"),
			vAlign = TEXT_VALIGN_BOTTOM,
			hAlign = TEXT_HALIGN_CENTER,
			htmlText = "<div c='FF0000'>10</div>/10",
			x = backpack.width/2,
			// width = 30,
			parent = backpack,
		}
		*/
		
		@updateItems()
		
		var itemSelected, itemSlot, touchPos, targetSlot = null
		@addEventListener(TouchEvent.START, function(ev){
			if(ev.target is ItemSlot){ // .name == "backpackItem"){ // && (itemSelected = ev.target.getChild("backpackItem"))){
				@extendedClickArea = stage.width
				itemSlot = ev.target
				itemSelected = itemSlot.item
				targetSlot = null
				
				// itemSelected.touchEnabled = false
				itemSelected.color = Color(0.9, 0.9, 0.99)
				// print "${itemSelected.pos} == ${itemSelected.localToLocal(itemSelected.pos, itemSlot)}"
				// itemSelected.pos = itemSelected.localToLocal(@parent)
				// itemSelected.parent = @parent
				itemSelected.changeParentAndSavePos(@game.hud)
				
				touchPos = @localToGlobal(ev.localPos)
			}
		}.bind(this))

		@moveEventId = stage.addEventListener(TouchEvent.MOVE, function(ev){
			if(itemSelected){ // ev.target.name == "backpackSlot"){
				// print "move: "..ev.localPos
				var curTouchPos = stage.localToGlobal(ev.localPos)
				var delta = curTouchPos - touchPos
				touchPos = curTouchPos
				
				itemSelected.pos += delta
				
				var slot = stage.findActorByPos(curTouchPos, function(actor){
					return actor is ItemSlot || actor is HudSlot
				})
				if(slot && slot !== targetSlot){
					targetSlot = slot
					slot.color = Color.WHITE
					var action = EaseAction(TweenAction {
						duration = 0.5,
						color = Color(1, 0.4, 0.4),
					}, Ease.PING_PONG)
					action.name = "selectTargetSlot"
					slot.replaceAction(action)
				}
			}
		}.bind(this))
		
		@addEventListener(TouchEvent.END, function(ev){
			if(itemSelected){ // ev.target.name == "backpackSlot"){
				if(!targetSlot || targetSlot == itemSlot){
					itemSelected.pos = itemSlot.size/2
					itemSelected.parent = itemSlot
					itemSelected.color = Color.WHITE
					itemSelected = null
				}else if(targetSlot is HudSlot){
					var itemInfo = Backpack.items[itemSlot.slotNum]
					targetSlot.setItem(itemInfo.type)
					itemSelected.pos = itemSlot.size/2
					itemSelected.parent = itemSlot
					itemSelected.color = Color.WHITE
					itemSelected = null
				}else{
					var itemInfo = Backpack.items[itemSlot.slotNum]
					var targetItemInfo = Backpack.items[targetSlot.slotNum]
					if(!targetItemInfo){
						var moveCount = math.ceil(itemInfo.count / 2)
						if(moveCount == itemInfo.count){
							Backpack.items[targetSlot.slotNum] = itemInfo
							delete Backpack.items[itemSlot.slotNum]
						}else{
							Backpack.items[targetSlot.slotNum] = {
								type = itemInfo.type,
								count = moveCount,
							}
							itemInfo.count -= moveCount
						}
					}else if(targetItemInfo.type == itemInfo.type){
						var moveCount = itemInfo.count
						targetItemInfo.count += moveCount
						delete Backpack.items[itemSlot.slotNum]
					}else{
						Backpack.items[itemSlot.slotNum] = targetItemInfo
						Backpack.items[targetSlot.slotNum] = itemInfo
					}
					@updateItems()
					itemSelected.detach()
				}
				itemSelected = itemSlot = targetSlot = null
				@extendedClickArea = 0
			}
		}.bind(this))
		
		/* @opacity = 0
		@addTweenAction {
			duration = 0.1,
			opacity = 1,
		} */
	},
	
	cleanup = function(){
		stage.removeEventListener(@moveEventId)
	},
	
	updateNumItems = function(){
		Backpack.numItemsByType = {}
		for(var _, item in Backpack.items){
			var count = 0
			if(item.type in Backpack.numItemsByType){
				count = Backpack.numItemsByType[item.type]
			}
			Backpack.numItemsByType[item.type] = count + item.count
		}
	},
	
	updateItems = function(){
		Backpack.updateNumItems()
		for(var _, slot in @slots){
			slot.removeChildren()
			slot.item = null
			slot.count = null
		}
		for(var slotNum, item in Backpack.items){
			var slot = @slots[slotNum] || continue
			slot.item = Sprite().attrs {
				name = "item",
				resAnim = res.get(@game.getResName("slot-item", item.type)),
				pivot = vec2(0.5, 0.5),
				pos = slot.size/2,
				priority = 1,
				parent = slot,
				touchEnabled = false,
			}
			slot.count = TextField().attrs {
				resFont = res.get("test"),
				vAlign = TEXT_VALIGN_BOTTOM,
				hAlign = TEXT_HALIGN_RIGHT,
				text = item.count,
				pos = slot.size - vec2(4, 5),
				priority = 2,
				parent = slot,
			}
		}
	},
}