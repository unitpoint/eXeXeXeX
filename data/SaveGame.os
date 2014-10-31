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

SaveGame = extends Actor {
	__construct = function(game){
		super()
		@game = game
		
		var bg = Box9Sprite().attrs {
			resAnim = res.get("panel"),
			// priority = 1,
			opacity = 0.5,
			parent = this
		}
		bg.setGuides(20, 20, 20, 20)
		// @size = bg.size = vec2(400, 300)
		// return;
		
		@title = PanelTitle(this, _T("Save game"), Color.fromInt(0xe87a7e))
		
		@slotButtons = []
		var numSlots, borderSize, paddingSize, saveExists = 3, vec2(80, 40), 40
		for(var i = 0; i < numSlots; i++){
			var button = MenuSlotButton(1).attrs {
				x = borderSize.x + (MenuSlotButton.SIZE.x + paddingSize) * i,
				y = borderSize.y,
				parent = this,
				slotNum = i,
				allowSave = false,
				onClick = function(){
					print "save ${@slotNum}"
					// @touchEnabled = false
					if(@allowSave){
						playMenuClickSound()
						game.saveGame(@slotNum)
					}else{
						// TODO: play warn sound
					}
				},
			}
			if(GAME_SETTINGS.saveSlots[i]){
				saveExists = true
				button.resAnim = res.get("save")
				button.note = GAME_SETTINGS.saveSlots[i].date.format(_T("j M\nH:i:s"))
				
				var onLongPressed = button.onLongPressed
				button.onLongPressed = function(){
					onLongPressed.call(this)
					@onLongPressed = null
					// @allowSave = true
					playMenuClickSound()
					game.saveGame(@slotNum)
				}
			}else{
				button.allowSave = true
				button.onLongPressed = null
				button.text = _T("EMPTY\nSLOT")
			}
			@slotButtons[] = button
		}
		@width = button.x + button.width + borderSize.x
		@height = button.y + button.height + borderSize.y
		
		if(saveExists){
			@noteField = BorderedText().attrs {
				resFont = res.get("test"),
				vAlign = TEXT_VALIGN_MIDDLE,
				hAlign = TEXT_HALIGN_CENTER,
				text = _T("long-press a slot to rewrite save game"),
				// linesOffset = -10,
				pos = @size * vec2(0.5, 0.95),
				// priority = 10,
				color = Color(0.7, 0.7, 0.7),
				borderColor = Color.fromInt(0xfce8ca),
				borderVisible = false,
				parent = this,
			}		
			@height += 20
		}
		bg.size = @size
	},
}