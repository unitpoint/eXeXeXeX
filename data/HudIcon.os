HudIcon = extends Box9Sprite {
	__construct = function(name){
		@resAnim = res.get(name)
		@size = vec2(HUD_ICON_SIZE, HUD_ICON_SIZE)
		@opacity = 0.5
		@touchChildrenEnabled = false
		
		var touching = false
		@addEventListener(TouchEvent.START, function(ev){
			touching = true
			@replaceTweenAction {
				name = "touching",
				duration = 0.2,
				opacity = 1,
				scale = 1.1,
				ease = Ease.CUBIC_IN_OUT,
			}
		}.bind(this))
		
		@addEventListener(TouchEvent.CLICK, function(ev){
			@onClicked(ev)
		}.bind(this))
		
		@addEventListener(TouchEvent.END, function(ev){
			touching = false
			@replaceTweenAction {
				name = "touching",
				duration = 0.2,
				opacity = 0.5,
				scale = 1,
				ease = Ease.CUBIC_IN_OUT,
			}
		}.bind(this))
	},
	
	onClicked = function(ev){
	
	},
}