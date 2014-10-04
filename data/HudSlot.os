HudSlot = extends Box9Sprite {
	__construct = function(game){
		super()
		@game = game
		// @name = name
		@resAnim = res.get("slot")
		@size = vec2(HUD_SLOT_SIZE, HUD_SLOT_SIZE)
		@opacity = 0.5
		@touchChildrenEnabled = false
		@item = @count = @itemType = null
	},
	
	clearItem = function(){
		@removeChildren()
		@item = @count = @itemType = null
	},
	
	updateItem = function(){
		var count = Backpack.numItemsByType[type]
		if(count > 0){
			@count.text = count
		}else{
			@clearItem()
		}
	},
	
	setItem = function(type){
		@clearItem()
		for(var _, hudSlot in @game.hudSlots){
			if(hudSlot.itemType == type){
				hudSlot.clearItem()
			}
		}
		@itemType = type
		@item = Sprite().attrs {
			name = "item",
			resAnim = res.get(@game.getResName("slot-item", type)),
			pivot = vec2(0.5, 0.5),
			pos = @size/2,
			priority = 1,
			parent = this,
			// touchEnabled = false,
		}
		@count = TextField().attrs {
			resFont = res.get("test"),
			vAlign = TEXT_VALIGN_BOTTOM,
			hAlign = TEXT_HALIGN_RIGHT,
			text = Backpack.numItemsByType[type],
			pos = @size - vec2(4, 5),
			priority = 2,
			parent = this,
		}
	},
}