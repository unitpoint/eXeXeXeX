Backpack = extends Actor {
	pack = ItemsPack(),

	__construct = function(game){
		super()
		@game = game
		@name  = "backpack"
		
		@pack.items = {
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
		}
		
		@cols = 4
		@rows = 4
		
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
		@updateItems()
	},
	
	updateItems = function(){
		@pack.updateActorItems(this)
	},
}