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

Joystick = extends Sprite {
	__construct = function(){
		super()
		
		@resAnim = res.get("joystick")
		@opacity = 0.25
		@extendedClickArea = @defaultExtendedClickArea = @width * 0.3
		@activeExtendedClickArea = @width * 1.5
		@touchEnabled = true
		
		@addEventListener(TouchEvent.START, @onEvent.bind(this))
		@addEventListener(TouchEvent.END, @onEvent.bind(this))
		@addEventListener(TouchEvent.MOVE, @onEvent.bind(this))
		
		@finger = Sprite().attrs {
			resAnim = res.get("finger"),
			parent = this,
			visible = false,
			pivot = vec2(0.5f, 0.5f),
			touchEnabled = false,
		}
		@active = false
		@dir = vec2(0, 0)
		
		@maxLen = 70
	},
		
	onEvent = function(ev){
		if(ev.type == TouchEvent.TOUCH_DOWN){
			@finger.visible = true
			
			@replaceTweenAction {
				name = "colorTween",
				duration = 0.2,
				color = Color(0.7, 0, 0),
			}
			
			@extendedClickArea = @activeExtendedClickArea
			@active = true
		}

		if(ev.type == TouchEvent.TOUCH_UP){
			@finger.visible = false
			
			@replaceTweenAction {
				name = "colorTween",
				duration = 0.2,
				color = Color(1, 1, 1),
			}
			
			@extendedClickArea = @defaultExtendedClickArea
			@active = false
		}

		if(ev.type == TouchEvent.MOVE){
		
		}

		var center = @size / 2
		@dir = (ev.localPosition - center).normalizeToMax(@maxLen)
		@finger.pos = center + @dir
		@dir /= @maxLen
		// @active || @dir = vec2(0, 0)
	}
}
