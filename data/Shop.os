Shop = extends Actor {
	__construct = function(game, name){
		super()
		@name = name || "ent-043"
		@game = game
		
		@cols = 4
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
		for(var y = 0; y < @rows; y++){
			for(var x = 0; x < @cols; x++){
				var slot = ItemSlot().attrs {
					name = "shopSlot",
					// resAnim = res.get("slot"),
					x = borderSize + (SLOT_SIZE + paddingSize) * x,
					y = borderSize + (SLOT_SIZE + paddingSize) * (y + 1),
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
		
		var trader = Box9Sprite().attrs {
			resAnim = res.get(@name),
			pivot = vec2(0, 0),
			pos = vec2(borderSize, borderSize),
			size = vec2(SLOT_SIZE, SLOT_SIZE),
			// scaleX = -1,
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
	}
}