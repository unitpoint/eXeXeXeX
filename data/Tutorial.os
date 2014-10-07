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

Tutorial = extends Object {
	animateDragFinger = function(params){
		var finger = params.finger || @{
			var finger = HandFinger().attrs {
				parent = params.target,
			}
			var updateCallback = params.updateCallback
			updateCallback && finger.addUpdate(0.3, function(){
				updateCallback(finger)
			})
			params.finger = finger
		}
		finger.pos = params.startPos
		finger.angle = params.startAngle
		finger.opacity = 0
		finger.replaceTweenAction {
			name = "tutorial",
			duration = 0.4,
			opacity = 1,
			doneCallback = function(){
				finger.addTimeout(0.4, function(){
					finger.animateTouch(function(){
						finger.replaceTweenAction {
							name = "tutorial",
							duration = 2,
							pos = params.endPos,
							angle = params.endAngle,
							ease = Ease.CUBIC_IN_OUT,
							doneCallback = function(){
								finger.animateUntouch(function(){
									finger.addTimeout(0.8, function(){
										finger.replaceTweenAction {
											name = "tutorial",
											duration = 0.3,
											opacity = 0,
											doneCallback = function(){
												finger.addTimeout(3, function(){
													@animateDragFinger(params)
												})
											},
										}
									})
								})
							},
						}
					})
				})
			},
		}
		return finger
	},
}