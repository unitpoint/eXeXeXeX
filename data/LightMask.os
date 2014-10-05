/******************************************************************************
* Copyright (C) 2014 Evgeniy Golovin (evgeniy.golovin@unitpoint.ru)
*
* Please feel free to contact me at anytime, 
* my email is evgeniy.golovin@unitpoint.ru, skype: egolovin
*
* eXeXeXeX is a 4X genre of strategy-based video game in which player 
* "eXplore, eXpand, eXploit, and eXterminate" the world
* 
* Latest source code
*	eXeXeXeX: https://github.com/unitpoint/eXeXeXeX
* 	OS2D engine: https://github.com/unitpoint/os2d
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
******************************************************************************/

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
			var elem = Sprite().attrs {
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
				scale = scale * math.random(0.95, 1.05),
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