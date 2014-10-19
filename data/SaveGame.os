SaveGame = extends Actor {
	__construct = function(game){
		super()
		@game = game
		
		var bg = Box9Sprite().attrs {
			resAnim = res.get("panel"),
			// priority = 1,
			opacity = 0.3,
			parent = this
		}
		bg.setGuides(20, 20, 20, 20)
		// @size = bg.size = vec2(400, 300)
		// return;
		
		@title = PanelTitle(this, _T("Save game"), Color.fromInt(0xe87a7e))
		
		@slotButtons = []
		var numSlots, borderSize, paddingSize, self = 3, vec2(80, 40), 40, this
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
		bg.size = @size
	},
}