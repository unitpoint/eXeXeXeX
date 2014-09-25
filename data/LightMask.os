LightMask = extends Actor {
	__construct = function(mask, fill){
		super()
		mask || mask = "light-mask"
		fill || fill = "light-fill"
		
		mask is ResAnim || mask = res.get(mask) as ResAnim || throw "ResAnim required for ${mask}"
		fill is ResAnim || fill = res.get(fill) as ResAnim || throw "ResAnim required for ${fill}"
		
		@mask = Sprite().attrs {
			resAnim = mask,
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			parent = this,
		}
		@pivot = vec2(0.5, 0.5)
		@size = @mask.size
		
		@fillLayer = Actor().attrs {
			pivot = vec2(0.5, 0.5),
			pos = vec2(0, 0),
			parent = this
		}
		@fillElements = []
		for(var i = 0; i < 4; i++){
			var elem = ColorRectSprite().attrs {
				resAnim = fill,
				pos = vec2(0, 0),
				pivot = vec2(0, 0),
			}
			elem.setAnimFrameRect(1, 1, elem.width-2, elem.height-2)
			@fillElements[] = elem
		}
		@fillElementSize = @fillElements[0].size
		
		@touchEnabled = false
		@touchChildrenEnabled = false
		
		@calculatedPos = null
		@animateLightScale = null
		@animateLightAdjustHandle = null
	},
	
	animateLight = function(scale, time, callback){
		var anim = function(scale){
			@replaceTweenAction {
				name = "animateLight",
				duration = 0.04, // math.random(0.05, 0.07),
				scale = scale * math.random(0.97, 1.03),
				ease = Ease.CUBIC_IN_OUT,
				doneCallback = function(){
					anim(scale)
				}.bind(this),
			}
		}.bind(this)
		@removeUpdate(@animateLightAdjustHandle)
		// this also support null
		if(@animateLightScale == scale){
			callback()
			return
		}
		time || time = 2
		var steps = 10 * time
		var start, delta, i = @scale, (scale - @scale) / steps, 0
		anim(start)
		// @scale = @animateLightScale
		@animateLightAdjustHandle = @addUpdate(time / steps, function(){
			if(++i == steps){
				anim(scale)
				@removeUpdate(@animateLightAdjustHandle)
				@animateLightAdjustHandle = null
				callback()
			}else{
				anim(start + delta * i)
			}
		}.bind(this))
		@animateLightScale = scale
	},
	
	updateDark = function(){
		var pos = @pos
		@calculatedPos == pos && return;
		@fillLayer.removeChildren()
		var size, parentSize = @size, @parent.size
		var pad = math.max(parentSize.x, parentSize.y)
		var halfSize = size/2
		var p1, p2 = pos - halfSize, pos + halfSize
		if(p1.x > 0){
			var elem = @fillElements[0]
			elem.pos = vec2(-p1.x - pad, -p1.y - pad)
			elem.scale = vec2(p1.x + pad + 1, parentSize.y + pad*2) / @fillElementSize
			elem.parent = @fillLayer
		}
		if(p1.y > 0){
			var elem = @fillElements[1]
			elem.pos = vec2(0, -p1.y - pad)
			elem.scale = vec2(size.x, p1.y + pad + 1) / @fillElementSize
			elem.parent = @fillLayer
		}
		if(p2.x < parentSize.x){
			var elem = @fillElements[2]
			elem.pos = vec2(size.x-1, -p1.y - pad)
			elem.scale = vec2(parentSize.x - p2.x + pad, parentSize.y + pad*2) / @fillElementSize
			elem.parent = @fillLayer
		}
		if(p2.y < parentSize.y){
			var elem = @fillElements[3]
			elem.pos = vec2(0, size.y-1)
			elem.scale = vec2(size.x, parentSize.y - p2.y + pad) / @fillElementSize
			elem.parent = @fillLayer
		}
		// print "updateMask: ${p1}, ${p2}"
	},
}