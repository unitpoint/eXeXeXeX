ItemSlot = extends Box9Sprite {
	__construct = function(game, owner, slotNum, resName){
		super()
		@game = game
		@owner = owner
		@slotNum = slotNum
		// @sumCount = sumCount
		@resAnim = res.get(resName || "slot")
		@size = vec2(SLOT_SIZE, SLOT_SIZE)
		@touchChildrenEnabled = false
		// @countEnabled = true
		// @spriteOpacity = 1
		@sprite = @countText = @_type = @_count = null
	},

	clearItem = function(){
		@removeChildren()
		@sprite = @countText = @_type = @_count = null
	},
	
	__get@isEmpty = function(){
		return !@sprite
	},
	
	__get@type = function(){
		return @_type
	},
	
	__set@type = function(type){
		@_type === type && return;
		// @clearItem()
		@_type = type
		@sprite.detach(); @sprite = null
		type && @sprite = Sprite().attrs {
			resAnim = res.get(@game.getSlotItemResName(type)),
			pivot = vec2(0.5, 0.5),
			pos = @size/2,
			priority = 1,
			parent = this,
			touchEnabled = false, // it will be detached while drgging
			// opacity = @spriteOpacity,
		}
	},
	
	__get@count = function(){
		return @_count // || (@sumCount ? @owner.pack.numItemsByType[@type] : @owner.pack.items[@slotNum].count)
	},
	
	__set@count = function(value){
		@_count === value && return;
		@_count = value
		@countText.detach(); @countText = null
		value && @countText = TextField().attrs {
			resFont = res.get("test"),
			vAlign = TEXT_VALIGN_BOTTOM,
			hAlign = TEXT_HALIGN_RIGHT,
			text = value,
			pos = @size - vec2(4, 5),
			priority = 2,
			parent = this,
		}
	},
	
	/* update = function(){
		var count = @count
		if(count > 0){
			@countEnabled && @countText.text = count
		}else{
			@clearItem()
		}
	}, */
}
