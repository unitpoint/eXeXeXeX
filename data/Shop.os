Shop = extends Actor {
	pack = ItemsPack(),
	
	__construct = function(game, name){
		super()
		@name = name || "ent-043"
		@game = game
		
		@pack.items = {
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
		}
		
		@cols = 4
		@rows = 3
		
		var bg = Box9Sprite().attrs {
			resAnim = res.get("panel"),
			// priority = 1,
			color = (Color.fromInt(0x77595a) * 2).clamp(),
			parent = this
		}
		bg.setGuides(20, 20, 20, 20)
		
		@title = PanelTitle(this, _T("Shop"))
		
		var borderSize = 10
		var paddingSize = 4
		
		@slots = []
		for(var y = 0; y < @rows; y++){
			for(var x = 0; x < @cols; x++){
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
		
		var backpack = Backpack(@game).attrs {
			// pivot = vec2(0, 0),
			x = @width + borderSize,
			parent = this,
		}
		@width = backpack.x + backpack.width
		@height = math.max(@height, backpack.height)
		/*
		var backpack = Backpack(@game).attrs {
			pivot = vec2(0, 1),
			pos = @size + vec2(borderSize, 0),
			parent = this,
		}
		@width = backpack.x + backpack.width
		*/
		
		@updateItems()
	},
	
	updateItems = function(){
		@pack.updateActorItems(this)
	},
	
	getSellPriceByType = function(type){
		return math.ceil(ITEMS_INFO[type].price * 0.95)
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
		@destCountText.text = 1
	},
}