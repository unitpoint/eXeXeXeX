Backpack = extends Actor {
	__construct = function(game){
		super()
		
		@cols = 4
		@rows = 3
		
		var bg = Box9Sprite().attrs {
			resAnim = res.get("panel"),
			// priority = 1,
			parent = this
		}
		bg.setGuides(20, 20, 20, 20)
		
		var temp = Sprite()
		temp.resAnim = res.get("slot")
		
		var slotSize = temp.size
		var borderSize = 10
		var paddingSize = 4
		
		@slots = []
		for(var y = 0; y < @rows; y++){
			for(var x = 0; x < @cols; x++){
				var slot = Sprite().attrs {
					resAnim = res.get("slot"),
					x = borderSize + (slotSize.x + paddingSize) * x,
					y = borderSize + (slotSize.y + paddingSize) * y,
					parent = this,
				}
				@slots[] = slot
			}
		}
		@width = slot.x + slot.width + borderSize
		@height = slot.y + slot.height + borderSize
		bg.size = @size
		
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
			vAlign = TextStyle.VALIGN_BOTTOM,
			hAlign = TextStyle.HALIGN_CENTER,
			htmlText = "<div c='FF0000'>10</div>/10",
			x = backpack.width/2,
			// width = 30,
			parent = backpack,
		}
		
		var slotNum = 0
		var items = [101, 102, 103, 201, 301, 401]
		while(#items > 0 && slotNum < #@slots){
			var i = math.random(#items)
			var item = Sprite().attrs {
				resAnim = res.get("item-"..items[i]),
				pivot = vec2(0.5, 0.5),
				pos = slot.size/2,
				parent = @slots[slotNum],
			}
			var count = TextField().attrs {
				resFont = res.get("test"),
				vAlign = TEXT_VALIGN_BOTTOM,
				hAlign = TEXT_HALIGN_RIGHT,
				text = math.random(1, 100)|0,
				pos = slot.size - vec2(4, 5),
				parent = @slots[slotNum++],
			}
			
			delete items[i]
		}
	},
}