HealthBar = extends Actor {
	__object = {
		_value = 0,
	},
	
	__construct = function(border, filler){
		// border || border = "hud-border-bg"
		filler || filler = "white"
		
		border is ResAnim || border = res.get(border) as ResAnim || throw "ResAnim required for ${border}"
		filler is ResAnim || filler = res.get(filler) as ResAnim || throw "ResAnim required for ${filler}"
		
		@border = Sprite().attrs {
			resAnim = border,
			priority = 1,
			parent = this,
			// pivot = vec2(0, 0),
			// pos = vec2(0, 0),
		}
		@filler = Box9Sprite().attrs {
			resAnim = filler,
			priority = 0,
			parent = this,
			// pivot = vec2(0, 0),
			// pos = vec2(0, 0),
		}
		@size = @filler.size = @border.size
		// @filler.scale = @border.size / @filler.size
		// @fillFullScaleX = @filler.scaleX
		@blinkUpdateHandle = null
		@value = 1
	},
	
	__get@value = function(){
		return @_value
	},
	
	__set@value = function(t){
		if(!t){
			throw "attempt set value to ${t}"
		}
		// t || throw "attempt value set to ${t}"
		// print "[${@__name}] value set to ${t}"
		t = t < 0 ? 0 : t > 1 ? 1 : t
		t == @_value && return;
		if(t >= 0.6){
			var color = Color(0, 0.78, 0)
		}else if(t >= 0.3){
			var color = Color(0.78, 0.78, 0)
		}else{
			var color = Color(0.78, 0, 0)
		}
		@_value = t
		@filler.color = color
		@filler.width = @width * t
		if(t < 0.25){
			@blinkUpdateHandle || @blinkUpdateHandle = @addUpdate(0.3, function(){
				@filler.visible = !@filler.visible
			}.bind(this))
		}else if(@blinkUpdateHandle){
			@filler.visible = true
			@removeUpdate(@blinkUpdateHandle)
			@blinkUpdateHandle = null
		}
	},
}
