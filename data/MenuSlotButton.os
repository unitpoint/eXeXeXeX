MenuSlotButton = extends Actor {
	SIZE = vec2(150, 200),
	
	__construct = function(longPressedTime){
		super()
		
		@bg = Box9Sprite().attrs {
			resAnim = res.get("button-01"),
			size = @SIZE,
			opacity = 0.9,
			parent = this,
		}
		@bg.setGuides(20, 20, 20, 20)
		
		@size = @originSize = @SIZE
		@touchChildrenEnabled = false
		@longPressedTime = longPressedTime || 2
		
		@addEventListener(TouchEvent.START, function(){ @onTouchStart() })
		@addEventListener(TouchEvent.END, function(){ @onTouchEnd() })
		@addEventListener(TouchEvent.CLICK, function(){ @onClick() })
		
		@pressHandle = null
		
		@textField = BorderedText().attrs {
			resFont = res.get("test_2"),
			vAlign = TEXT_VALIGN_MIDDLE,
			hAlign = TEXT_HALIGN_CENTER,
			// text = _T("NEW\nGAME"),
			linesOffset = -10,
			pos = @originTextPos = @size/2,
			// priority = 10,
			color = Color.fromInt(0x391a05),
			borderColor = Color(0.7, 0.7, 0.7), // Color.fromInt(0xfce8ca),
			parent = this,
		}
		
		@noteField = BorderedText().attrs {
			resFont = res.get("test"),
			vAlign = TEXT_VALIGN_BOTTOM,
			hAlign = TEXT_HALIGN_CENTER,
			// text = _T("NEW\nGAME"),
			// linesOffset = -10,
			pos = @originNotePos = @size * vec2(0.5, 0.85),
			// priority = 10,
			color = Color.fromInt(0x391a05),
			borderColor = Color(0.7, 0.7, 0.7), // Color.fromInt(0xfce8ca),
			parent = this,
		}
		
		@sprite = Sprite().attrs {
			pivot = vec2(0.5, 0.5),
			pos = @originSpritePos = @size * vec2(0.5, 0.35),
			parent = this,
		}
	},
	
	__get@text = function(){
		return @textField.text
	},
	__set@text = function(value){
		@textField.text = value
	},
	
	__get@note = function(){
		return @noteField.text
	},
	__set@note = function(value){
		@noteField.text = value
	},
	
	__get@resAnim = function(){
		return @sprite.resAnim
	},
	__set@resAnim = function(value){
		@sprite.resAnim = value
	},
	
	onTouchStart = function(ev){
		@bg.resAnim = res.get("button-01-pressed")
		@bg.size = @originSize
		@textField.pos = @originTextPos + vec2(2, 2)
		@noteField.pos = @originNotePos + vec2(2, 2)
		@sprite.pos = @originSpritePos + vec2(2, 2)
		
		@removeTimeout(@pressHandle)
		@pressHandle = @addTimeout(@longPressedTime, function(){
			@onLongPressed()
		})
		print "onTouchStart"
	},
	
	onTouchEnd = function(ev){
		@bg.resAnim = res.get("button-01")
		@bg.size = @originSize
		@textField.pos = @originTextPos
		@noteField.pos = @originNotePos
		@sprite.pos = @originSpritePos
		@removeTimeout(@pressHandle); @pressHandle = null
		print "onTouchEnd"
	},
	
	onClick = function(ev){
		print "onClick"
	},
	
	onLongPressed = function(){
		@bg.color = Color.WHITE
		@bg.replaceTweenAction {
			name = "bump",
			duration = 0.5,
			color = Color(1.0, 0.5, 0.5),
			ease = Ease.PING_PONG,
		}
		print "onLongPressed"
	},

}