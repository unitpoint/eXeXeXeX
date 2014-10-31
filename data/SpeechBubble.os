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

SpeechBubble = extends Actor {
	__construct = function(game, type, doneCallback){
		super()
		@game = game
		@type = type
		@doneCallback = doneCallback
		@touchChildrenEnabled = false
		
		@bubble = Sprite().attrs {
			resAnim = res.get("speech-bubble"),
			priority = 1,
			opacity = 0.5,
			parent = this,
		}
		@size = @bubble.size
		
		var bubbleCorner = vec2(6, 129) / vec2(156, 140)
		@pivot = bubbleCorner
		// @angle = -10
		@scale = 0.7
		
		var bubbleCenter = vec2(80, 61) / vec2(156, 140)
		@item = Sprite().attrs {
			resAnim = res.get(@game.getSlotItemResName(type)),
			pivot = vec2(0.5, 0.5),
			pos = bubbleCenter * @size,
			priority = 2,
			parent = this,
		}
		
		@_closing = false
		@opacity = 0
		@addTweenAction {
			name = "fade",
			duration = 1,
			opacity = 1,
			doneCallback = function(){
				@addTimeout(3, function(){
					@close()
				})
			},
		}
		@addEventListener(TouchEvent.CLICK, function(){
			@close()
		})
	},
	
	close = function(){
		if(!@_closing){
			@_closing = true
			@replaceTweenAction {
				name = "fade",
				duration = 1,
				opacity = 0,
				detachTarget = true,
				doneCallback = @doneCallback,
			}
		}
	},
}