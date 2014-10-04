HudIcon = extends Box9Sprite {
	STATE_SELECTING = 1,
	STATE_SELECTED = 2,
	STATE_UNSELECTING = 3,
	STATE_UNSELECTED = 4,
	
	__construct = function(name){
		@name = name
		@resAnim = res.get(name)
		@size = vec2(HUD_ICON_SIZE, HUD_ICON_SIZE)
		@opacity = 0.9
		@touchChildrenEnabled = false
		
		@state = @STATE_UNSELECTED
		@clicked = false
		
		@addEventListener(TouchEvent.START, function(ev){
			@clicked = false
			@animSelectIcon()
		}.bind(this))

		var timeoutHandle = null
		@addEventListener(TouchEvent.END, function(ev){
			timeoutHandle = @addTimeout(0.01, @animUnselectIcon.bind(this))
		}.bind(this))
		
		@addEventListener(TouchEvent.CLICK, function(ev){
			@removeTimeout(timeoutHandle)
			@state == @STATE_SELECTED && @animUnselectIcon()
			@clicked = true
			@onClicked(ev)
		}.bind(this))		
	},
	
	setResName = function(name){
		@resAnim = res.get(name)
		@size = vec2(HUD_ICON_SIZE, HUD_ICON_SIZE)
	},
	
	animSelectIcon = function(){
		if(@state != @STATE_SELECTING && @state != @STATE_SELECTED){
			@state = @STATE_SELECTING
			@replaceTweenAction {
				name = "select",
				duration = 0.2,
				opacity = 1,
				scale = 1.1,
				ease = Ease.CUBIC_IN_OUT,
				doneCallback = function(){
					@state = @STATE_SELECTED
					@clicked && @animUnselectIcon()
				}.bind(this),
			}
		}
	},
	
	animUnselectIcon = function(){
		if(@state != @STATE_UNSELECTING && @state != @STATE_UNSELECTED){
			@state = @STATE_UNSELECTING
			@replaceTweenAction {
				name = "select",
				duration = 0.2,
				opacity = 0.9,
				scale = 1,
				ease = Ease.CUBIC_IN_OUT,
				doneCallback = function(){
					@state = @STATE_UNSELECTED
					@clicked = false
				}.bind(this),
			}
		}
	},
	
	onClicked = function(ev){
	
	},
}