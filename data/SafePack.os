SafePack = extends Actor {
	__construct = function(game, entItem){
		super()
		// @name = name || "ent-043"
		@game = game
		@entItem = entItem
		@cols = entItem.cols
		@rows = entItem.rows
		@pack = entItem.pack
		@touchEnabled = false
		@tutorial = null
		
		var borderSize, paddingSize = 10, 4
		
		@backpack = Backpack(@game).attrs {
			// pivot = vec2(0, 0),
			// x = @width + borderSize,
			parent = this,
		}
		
		var bg = Box9Sprite().attrs {
			resAnim = res.get("panel"),
			// priority = 1,
			color = (Color.fromInt(0x5a5977) * 2.3), // .clamp(),
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
		
		@title = PanelTitle(bg, _T("Safe"), bg.color) // Color(0.99, 0.99, 0.7))
		@title.x = bg.width - @title.width
		
		@width = bg.x + bg.width
		@height = math.max(bg.height, @backpack.height)
		
		var entIcon = Box9Sprite().attrs {
			resAnim = res.get(@entItem.name),
			x = borderSize + (SLOT_SIZE + paddingSize) * (@cols - 1),
			y = borderSize + (SLOT_SIZE + paddingSize) * 0,
			size = vec2(SLOT_SIZE, SLOT_SIZE),
			// scaleX = -1,
			parent = bg,
		}
		
		@updateItems()
	},
	
	updateItems = function(){
		@pack.updateActorItems(this)
	},
}