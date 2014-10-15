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

HealthBar = extends Actor {
	__object = {
		_value = 0,
	},
	
	__construct = function(border, filler){
		// border || border = "hud-border-bg"
		filler || filler = "white"
		
		border is ResAnim || border = res.get(border) as ResAnim || throw "ResAnim required for ${border}"
		filler is ResAnim || filler = res.get(filler) as ResAnim || throw "ResAnim required for ${filler}"
		
		@border = Box9Sprite().attrs {
			resAnim = border,
			priority = 1,
			parent = this,
			// pivot = vec2(0, 0),
			// pos = vec2(0, 0),
		}
		var guide = math.ceil(@border.height/3)
		@border.setGuides(guide, guide, guide, guide)
		
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
	
	__set@width = function(value){
		super(@border.width = value)
		var saveValue = @_value
		@_value = 0
		@value = saveValue
	},
	
	__set@height = function(value){
		super(@border.height = @filler.height = value)
		var guide = math.ceil(value/3)
		@border.setGuides(guide, guide, guide, guide)
		/* var saveValue = @_value
		@_value = 0
		@value = saveValue */
	},
	
	__set@size = function(value){
		@width = value.x
		@height = value.y
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
			var color = Color.fromInt(0x87d422) // (0, 0.78, 0)
		}else if(t >= 0.3){
			var color = Color.fromInt(0xebd628) // (0.78, 0.78, 0)
		}else{
			var color = Color.fromInt(0xe3361a) // (0.78, 0, 0)
		}
		@_value = t
		@filler.color = color
		@filler.width = @width * t
		if(t < 0.25){
			@blinkUpdateHandle || @blinkUpdateHandle = @addUpdate(0.3, function(){
				@filler.visible = !@filler.visible
			})
		}else if(@blinkUpdateHandle){
			@filler.visible = true
			@removeUpdate(@blinkUpdateHandle)
			@blinkUpdateHandle = null
		}
	},
}
