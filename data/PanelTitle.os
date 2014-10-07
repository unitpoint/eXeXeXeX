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

PanelTitle = extends Actor {
	__construct = function(parent, title, color){
		super()
		@pivot = vec2(0, 1)
		@pos = vec2(0, 4)
		@parent = parent
		
		@bg = Box9Sprite().attrs {
			resAnim = res.get("panel-title"),
			color = color || Color.WHITE,
			parent = this,
		}
		
		var guide = math.floor(@bg.height/2)
		@bg.setGuides(guide, guide, guide, guide)
		@height = @bg.height = 44
		
		var side, vertSide = 10, 13
		@text = TextField().attrs {
			resFont = res.get("test_2"),
			vAlign = TEXT_VALIGN_BOTTOM,
			hAlign = TEXT_HALIGN_LEFT,
			text = title,
			pos = vec2(side, @height - vertSide),
			priority = 10,
			color = Color.fromInt(0x391a05),
			parent = this,
		}
		var textPos, textSize = @text.textPos, @text.textSize
		@width = @bg.width = @text.x + textPos.x + textSize.x + side*1.5
		
		@textShadow = []
		var cloneText = function(delta, color){
			var text = TextField().attrs {
				resFont = @text.resFont,
				vAlign = @text.vAlign,
				hAlign = @text.hAlign,
				text = @text.text,
				pos = @text.pos + delta,
				// priority = 0,
				color = color || Color.WHITE,
				parent = this,
			}
			@textShadow[] = text
		}
		
		var color = Color.fromInt(0xfce8ca)
		for(var x = -1; x < 2; x+=2){
			for(var y = -1; y < 2; y+=2){
				cloneText(vec2(x, y), color)
			}
		}
		// print "text pos: ${@text.textPos}, size: ${@text.textSize}"
	},
}