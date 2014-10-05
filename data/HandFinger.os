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

HandFinger = extends Actor {
	__construct = function(){
		super()
		@touchEnabled = false
		@touchChildrenEnabled = false
		@finger = Sprite().attrs {
			resAnim = res.get("hand-finger"),
			pivot = vec2(0.618, 0.02),
			priority = 1,
			angle = -10,
			parent = this,
		}
		@circle = Sprite().attrs {
			resAnim = res.get("touch-circle"),
			pivot = vec2(0.5, 0.5),
			opacity = 0,
			parent = this,
		}
		@timeoutHandle = null
	},
	
	animateUntouch = function(doneCallback){
		@removeTimeout(@timeoutHandle); @timeoutHandle = null
		@finger.replaceTweenAction {
			name = "animation",
			duration = 0.4,
			scale = 1,
			// angle = -10,
			ease = Ease.QUAD_IN_OUT,
			doneCallback = doneCallback,
		}
	},
	
	animateTouch = function(doneCallback){
		@circle.scale = 0.1
		@circle.opacity = 0
		@finger.replaceTweenAction {
			name = "animation",
			duration = 0.5,
			scale = 0.93,
			angle = -12,
			ease = Ease.QUAD_IN_OUT,
		}
		@removeTimeout(@timeoutHandle)
		@timeoutHandle = @addTimeout(0.25, function(){
			@circle.replaceTweenAction {
				name = "animation",
				duration = 0.1,
				opacity = 1,
			}
			@circle.addTweenAction {
				name = "animation",
				duration = 0.5,
				scale = 0.7,
				ease = Ease.QUAD_IN,
				doneCallback = function(){
					@circle.replaceTweenAction {
						name = "animation",
						duration = 0.5,
						opacity = 0,
						scale = 1,
						ease = Ease.QUAD_OUT,
						doneCallback = doneCallback,
					}
				}.bind(this),
			}
		}.bind(this))
	},
}