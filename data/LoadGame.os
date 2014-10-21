LoadGame = extends Actor {
	__construct = function(game){
		super()
		@game = game
		
		var numSlots = 3
		if(game.saveSlotNum){
			var bg = Box9Sprite().attrs {
				resAnim = res.get("panel"),
				// priority = 1,
				opacity = 0.5,
				parent = this
			}
			bg.setGuides(20, 20, 20, 20)
			// @size = bg.size = vec2(400, 300)
			// return;
			
			/* if(game.saveSlotNum){
				@title = PanelTitle(this, game.saveSlotNum ? _T("Load game") : _T("Main menu"))
			} */
			@title = PanelTitle(this, _T("Load game"), Color.fromInt(0x97ec2a))
		}else{
			var saveExists = false
			for(var i = 0; i < numSlots; i++){
				if(GAME_SETTINGS.saveSlots[i]){
					saveExists = true
					break
				}
			}
			if(!saveExists){
				@size = @game.size
				@noteField = BorderedText().attrs {
					resFont = res.get("test_2"),
					vAlign = TEXT_VALIGN_BOTTOM,
					hAlign = TEXT_HALIGN_CENTER,
					text = _T("Click anywhere to start"),
					// linesOffset = -10,
					pos = @size * vec2(0.5, 0.95),
					// priority = 10,
					// color = Color(0.7, 0.7, 0.7),
					// borderColor = Color.fromInt(0xfce8ca),
					color = Color(0.9, 0.9, 0.9),
					borderColor = Color.BLACK,
					// borderVisible = false,
					parent = this,
				}
				@addEventListener(TouchEvent.CLICK, function(){
					var slotNum = 0
					print "start ${slotNum}"
					playMenuClickSound()
					@game.loadGame(slotNum)
				})
				return
			}
		}
		
		@slotButtons = []
		var borderSize, paddingSize, saveExists = vec2(80, 40), 40
		for(var i = 0; i < numSlots; i++){
			var button = MenuSlotButton(2).attrs {
				x = borderSize.x + (MenuSlotButton.SIZE.x + paddingSize) * i,
				y = borderSize.y,
				parent = this,
				// text = _T("NEW\nGAME"),
				slotNum = i,
				onClick = function(){
					print "start ${@slotNum}"
					// @touchEnabled = false
					playMenuClickSound()
					game.loadGame(@slotNum)
				},
			}
			@slotButtons[] = button
			if(GAME_SETTINGS.saveSlots[i]){
				saveExists = true
				button.resAnim = res.get("load")
				button.note = GAME_SETTINGS.saveSlots[i].date.format(_T("j M\nH:i:s"))
				
				var onLongPressed = button.onLongPressed
				button.onLongPressed = function(){
					onLongPressed.call(this)
					@onLongPressed = null
					@resAnim = null
					@note = ""
					@text = _T("NEW\nGAME")
					delete GAME_SETTINGS.saveSlots[@slotNum]
					saveGameSettings()
					playMenuClickSound()
					// self.resetSaveSlotNum(@slotNum)
				}
			}else{
				button.onLongPressed = null
				button.text = _T("NEW\nGAME")
				if(!game.saveSlotNum){
					var emptySlots = true
					for(var j = i+1; j < numSlots; j++){
						if(GAME_SETTINGS.saveSlots[j]){
							emptySlots = false
							break
						}
					}
					emptySlots && break
				}
			}
		}
		@width = button.x + button.width + borderSize.x
		@height = button.y + button.height + borderSize.y
		
		if(saveExists){
			@noteField = BorderedText().attrs {
				resFont = res.get("test"),
				vAlign = TEXT_VALIGN_MIDDLE,
				hAlign = TEXT_HALIGN_CENTER,
				text = _T("long-press a slot to delete save game"),
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