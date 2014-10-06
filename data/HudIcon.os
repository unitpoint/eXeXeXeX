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
		})

		var timeoutHandle = null
		@addEventListener(TouchEvent.END, function(ev){
			timeoutHandle = @addTimeout(0.01, @animUnselectIcon.bind(this))
		})
		
		@addEventListener(TouchEvent.CLICK, function(ev){
			@removeTimeout(timeoutHandle)
			@state == @STATE_SELECTED && @animUnselectIcon()
			@clicked = true
			@onClicked(ev)
		})		
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
				},
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
				},
			}
		}
	},
	
	onClicked = function(ev){
	
	},
}