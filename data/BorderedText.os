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

BorderedText = extends Actor {
	__construct = function(){
		super()
		@touchChildrenEnabled = false
		
		@border = []
		for(var x = -1; x < 2; x+=2){
			for(var y = -1; y < 2; y+=2){
				var text = TextField().attrs {
					pos = vec2(x, y),
					color = Color.BLACK,
					// visible = false,
					priority = 1,
					parent = this,
				}
				@border[] = text
			}
		}
		
		@textField = TextField().attrs {
			color = Color.WHITE,
			priority = 2,
			parent = this,
		}
	},
	
	_applyBorderValue = function(name, value){
		for(var _, text in @border){
			text[name] = value
		}
	},
	
	_applyValue = function(name, value){
		@textField[name] = value
		@_applyBorderValue(name, value)
	},
	
	__get@borderVisible = function(value){
		return @border[0].visible
	},
	__set@borderVisible = function(value){
		@_applyBorderValue("visible", value)
	},
	
	__get@borderColor = function(value){
		return @border[0].color
	},
	__set@borderColor = function(value){
		@_applyBorderValue("color", value)
	},
	
	__get@color = function(value){
		return super() // @border[0].color
	},
	__set@color = function(value){
		super(value)
		@textField.color = value
	},
	
	__get@style = function(){
		throw "style is deprecated"
	},
	__set@style = function(value){
		throw "style is deprecated"
	},

	__get@textPos = function(){
		return @textField.textPos
	},
	__get@textSize = function(){
		return @textField.textSize
	},
	
	__get@text = function(){
		return @textField.text
	},
	__set@text = function(value){
		@_applyValue("text", value)
	},
	
	__set@htmlText = function(value){
		@_applyValue("htmlText", value)
	},
	
	__get@fontSize2Scale = function(){
		return @textField.fontSize2Scale
	},
	__set@fontSize2Scale = function(value){
		@_applyValue("fontSize2Scale", value)
	},
	
	__get@vAlign = function(){
		return @textField.vAlign
	},
	__set@vAlign = function(value){
		@_applyValue("vAlign", value)
	},
	
	__get@hAlign = function(){
		return @textField.hAlign
	},
	__set@hAlign = function(value){
		@_applyValue("hAlign", value)
	},
	
	__get@multiline = function(){
		return @textField.multiline
	},
	__set@multiline = function(value){
		@_applyValue("multiline", value)
	},
	
	__get@breakLongWords = function(){
		return @textField.breakLongWords
	},
	__set@breakLongWords = function(value){
		@_applyValue("breakLongWords", value)
	},
	
	__get@linesOffset = function(){
		return @textField.linesOffset
	},
	__set@linesOffset = function(value){
		@_applyValue("linesOffset", value)
	},
	
	__get@resFont = function(){
		return @textField.resFont
	},
	__set@resFont = function(value){
		@_applyValue("resFont", value)
	},
}