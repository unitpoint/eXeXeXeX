DragndropItems = extends Actor {
	__construct = function(game){
		super()
		@game = game
		@touchEnabled = false
		
		var findTargetFunc, handleDragndrop
		
		@mode = null
		@itemSelected = @itemSlot = @touchPos = @targetSlot = null
		
		@startEventId = stage.addEventListener(TouchEvent.START, function(ev){
			if(ev.target is ItemSlot){
				if(ev.target is HudSlot){
					@mode = "hud"
					findTargetSlot = @findHudTargetSlot.bind(this)
					handleDragndrop = @handleHudDragndrop.bind(this)
				}else if(ev.target.owner is Backpack){
					@mode = "backpack"
					findTargetSlot = @findBackpackTargetSlot.bind(this)
					handleDragndrop = @handleBackpackDragndrop.bind(this)
				}else if(ev.target.owner is Shop){
					@mode = "shop"
					findTargetSlot = @findShopTargetSlot.bind(this)
					handleDragndrop = @handleShopDragndrop.bind(this)
				}else{
					throw "unknown item owner: ${ev.target.owner.classname}"
				}
				
				// @extendedClickArea = stage.width
				@itemSlot = ev.target
				@itemSelected = @itemSlot.sprite
				@targetSlot = null
				
				// itemSelected.touchEnabled = false
				@itemSelected.color = Color(0.9, 0.9, 0.99)
				// print "${itemSelected.pos} == ${itemSelected.localToLocal(itemSelected.pos, itemSlot)}"
				// itemSelected.pos = itemSelected.localToLocal(@parent)
				// itemSelected.parent = @parent
				@itemSelected.changeParentAndSavePos(stage)
				
				if(@mode == "backpack" && @game.shop){
					@game.shop.showSell(@itemSlot)
				}else if(@mode == "shop"){
					@game.shop.showBuy(@itemSlot)
				}
				
				@touchPos = stage.localToGlobal(ev.localPos)
			}
		}.bind(this))

		@moveEventId = stage.addEventListener(TouchEvent.MOVE, function(ev){
			if(@itemSelected){ // ev.target.name == "backpackSlot"){
				// print "move: "..ev.localPos
				var curTouchPos = stage.localToGlobal(ev.localPos)
				var delta = curTouchPos - @touchPos
				@touchPos = curTouchPos
				
				@itemSelected.pos += delta
				
				var slot = stage.findActorByPos(curTouchPos, findTargetSlot)
				if(slot !== @targetSlot){
					@targetSlot = slot
					if(slot){
						slot.color = Color.WHITE
						var action = EaseAction(TweenAction {
							duration = 0.5,
							color = Color(1, 0.4, 0.4),
						}, Ease.PING_PONG)
						action.name = "selectTargetSlot"
						slot.replaceAction(action)
					}
				}
			}
		}.bind(this))
		
		@endEventId = stage.addEventListener(TouchEvent.END, function(ev){
			if(@itemSelected){ // ev.target.name == "backpackSlot"){
				if(@mode == "backpack" && @game.shop){
					// @game.shop.targetSlot.clearItem()
					@game.shop.endShowSell()
				}
				if(!@targetSlot || @targetSlot == @itemSlot){
					@itemSelected.pos = @itemSlot.size/2
					@itemSelected.parent = @itemSlot
					@itemSelected.color = Color.WHITE
					@itemSelected = null
				}else{
					handleDragndrop()
				}
				@itemSelected = @itemSlot = @targetSlot = null
				// @extendedClickArea = 0
			}
		}.bind(this))
	},
	
	findBackpackTargetSlot = function(actor){
		return actor is ItemSlot || actor is HudSlot
	},
	
	handleBackpackDragndrop = function(){
		var owner = @itemSlot.owner
		if(@targetSlot is HudSlot){
			var itemInfo = owner.pack.items[@itemSlot.slotNum]
			@targetSlot.type = itemInfo.type
			@itemSelected.pos = @itemSlot.size/2
			@itemSelected.parent = @itemSlot
			@itemSelected.color = Color.WHITE
		}else{
			var itemInfo = owner.pack.items[@itemSlot.slotNum]
			var targetItemInfo = owner.pack.items[@targetSlot.slotNum]
			if(!targetItemInfo){
				var moveCount = math.ceil(itemInfo.count / 2)
				if(moveCount == itemInfo.count){
					owner.pack.items[@targetSlot.slotNum] = itemInfo
					delete owner.pack.items[@itemSlot.slotNum]
				}else{
					owner.pack.items[@targetSlot.slotNum] = {
						type = itemInfo.type,
						count = moveCount,
					}
					itemInfo.count -= moveCount
				}
			}else if(targetItemInfo.type == itemInfo.type){
				var moveCount = itemInfo.count
				targetItemInfo.count += moveCount
				delete owner.pack.items[@itemSlot.slotNum]
			}else{
				owner.pack.items[@itemSlot.slotNum] = targetItemInfo
				owner.pack.items[@targetSlot.slotNum] = itemInfo
			}
			// var backpack = @findParentOf(@itemSlot, Backpack)
			owner.updateItems()
			
			@itemSelected.detach()
		}
	
	},
	
	findShopTargetSlot = function(slot){
		return slot is ItemSlot
			&& (slot.isEmpty || slot.type == @itemSlot.type)
			&& slot.owner is Backpack 
			&& slot is HudSlot == false
	},
	
	handleShopDragndrop = function(){
		@itemSelected.pos = @itemSlot.size/2
		@itemSelected.parent = @itemSlot
		@itemSelected.color = Color.WHITE
	},
	
	findHudTargetSlot = function(actor){
		return (actor is ItemSlot && actor.owner is Backpack) || actor is HudSlot
	},
	
	handleHudDragndrop = function(){
		@itemSelected.pos = @itemSlot.size/2
		@itemSelected.parent = @itemSlot
		@itemSelected.color = Color.WHITE
	},
	
	cleanup = function(){
		stage.removeEventListener(@startEventId)
		stage.removeEventListener(@moveEventId)
		stage.removeEventListener(@endEventId)
	},
	
	findParentOf = function(actor, ClassType){
		for(; actor;){
			actor is ClassType && return actor;
			actor = actor.parent
		}
	},
}