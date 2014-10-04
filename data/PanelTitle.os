PanelTitle = extends Box9Sprite {
	__construct = function(parent, title){
		super()
		@resAnim = res.get("panel-title")
		@pivot = vec2(0, 1)
		@pos = vec2(0, 4)
		@parent = parent
		
		var guide = math.floor(@height/2)
		@setGuides(guide, guide, guide, guide)
		@height = 44
		
		var side, vertSide = 10, 13
		@text = TextField().attrs {
			resFont = res.get("test_2"),
			vAlign = TEXT_VALIGN_BOTTOM,
			hAlign = TEXT_HALIGN_LEFT,
			text = title,
			pos = vec2(side, @height - vertSide),
			priority = 10,
			color = Color.fromInt(0x391a05),
			parent = this,
		}
		var textPos, textSize = @text.textPos, @text.textSize
		@width = @text.x + textPos.x + textSize.x + side*1.5
		
		@textShadow = []
		var cloneText = function(delta, color){
			var text = TextField().attrs {
				resFont = @text.resFont,
				vAlign = @text.vAlign,
				hAlign = @text.hAlign,
				text = @text.text,
				pos = @text.pos + delta,
				// priority = 0,
				color = color || Color.WHITE,
				parent = this,
			}
			@textShadow[] = text
		}.bind(this)
		
		var color = Color.fromInt(0xfce8ca)
		for(var x = -1; x < 2; x+=2){
			for(var y = -1; y < 2; y+=2){
				cloneText(vec2(x, y), color)
			}
		}
		// print "text pos: ${@text.textPos}, size: ${@text.textSize}"
	},
}