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

var enumCount = 0
LAYER_TILES = enumCount++
LAYER_DECALS = enumCount++
LAYER_MONSTERS = enumCount++
LAYER_PLAYER = enumCount++
LAYER_FALLING_TILES = enumCount++
LAYER_COUNT = enumCount

TILE_FADE_SIZE = 32

TILE_TYPE_EMPTY = 0
ITEM_TYPE_EMPTY = 0

TILE_TYPE_GRASS = 1
TILE_TYPE_CHERNOZEM = 8
TILE_TYPE_ROCK = 9
TILE_TYPE_DOOR_01 = 16
TILE_TYPE_LADDERS = 17
TILE_TYPE_TRADE_STOCK = 24

TILE_PRIORITY_BASE = 2
TILE_PRIORITY_DOOR = 3
TILE_PRIORITY_FALLING = 4

GAME_PRIORITY_BG = 1
GAME_PRIORITY_VIEW = 2
GAME_PRIORITY_LIGHTMASK = 3
GAME_PRIORITY_HUD = 4
// GAME_PRIORITY_HUD_INVENTARY = 4
// GAME_PRIORITY_HUD_JOYSTICK = 5
GAME_PRIORITY_DRAGNDROP = 5
GAME_PRIORITY_FADEIN = 10

HUD_ICON_SIZE = 80
HUD_ICON_INDENT = 10

// HUD_SLOT_SIZE = 80
// HUD_SLOT_INDENT = 5

SLOT_SIZE = 80
SLOT_INDENT = 5

TILES_INFO = {
	[TILE_TYPE_GRASS] = {
		strength = 3,
	},
	[TILE_TYPE_CHERNOZEM] = {
		variants = 3,
		strength = 6,
		// damageDelay = 0.1,
	},
	[TILE_TYPE_ROCK] = {
		// variants = 1,
	},
	/* [TILE_TYPE_LADDERS] = {
		strength = 0,
	}, */
	2 = {
		strength = 50,
		variants = 2,
	},
	[TILE_TYPE_DOOR_01] = {
		class = "Door",
		// door = true,
		handle = "door-handle",
		handleShadow = "door-handle-shadow",
	},
	[TILE_TYPE_TRADE_STOCK] = {
		variants = 4,
	},
}

ITEM_TYPE_COAL = 7
ITEM_TYPE_GOLD = 10
ITEM_TYPE_SHOVEL = 11
ITEM_TYPE_PICK_01 = 12
ITEM_TYPE_PICK_02 = 13
ITEM_TYPE_PICK_03 = 14
ITEM_TYPE_BULLETS = 15
ITEM_TYPE_STAMINA = 16
ITEM_TYPE_LADDERS = 17

ITEM_TYPE_CANDY = 102

ITEMS_INFO = {
	1 = {
		hasTileSprite = true,
		strengthScale = 1.1,
		price = 50,
		canBuy = false,
	},
	2 = {
		hasTileSprite = true,
		strengthScale = 1.15,
		price = 75,
		canBuy = false,
	},
	3 = {
		hasTileSprite = true,
		strengthScale = 1.2,
		price = 100,
		canBuy = false,
	},
	4 = {
		hasTileSprite = true,
		strengthScale = 1.1,
		price = 60,
		canBuy = false,
	},
	5 = {
		hasTileSprite = true,
		strengthScale = 1.1,
		price = 65,
		canBuy = false,
	},
	6 = {
		hasTileSprite = true,
		strengthScale = 1.1,
		price = 55,
		canBuy = false,
	},
	[ITEM_TYPE_COAL] = {
		hasTileSprite = true,
		strengthScale = 1.5,
		price = 15,
		canBuy = false,
	},
	8 = {
		hasTileSprite = true,
		strengthScale = 1.1,
		price = 25,
		canBuy = false,
	},
	9 = {
		hasTileSprite = true,
		strengthScale = 1.5,
		price = 150,
		canBuy = false,
	},
	[ITEM_TYPE_GOLD] = {
		hasTileSprite = true,
		variants = 2,
		strengthScale = 2,
		price = 95,
		canBuy = false,
	},
	[ITEM_TYPE_SHOVEL] = {
		strengthScale = 1.1,
		price = 100,
		pickDamage = 1,
	},
	[ITEM_TYPE_PICK_01] = {
		strengthScale = 2,
		price = 200,
		pickDamage = 2,
	},
	[ITEM_TYPE_PICK_02] = {
		strengthScale = 4,
		price = 500,
		pickDamage = 4,
	},
	[ITEM_TYPE_PICK_03] = {
		strengthScale = 6,
		price = 900,
		pickDamage = 8,
	},
	[ITEM_TYPE_BULLETS] = {
		strengthScale = 1.1,
		price = 1,
		canBuy = false,
	},
	[ITEM_TYPE_STAMINA] = {
		strengthScale = 4,
		incStamina = 25,
		price = 1000,
	},
	[ITEM_TYPE_LADDERS] = {
		strengthScale = 1.1,
		price = 20,
	},
	101 = {
		stamina = 100,
		price = 100,
	},
	[ITEM_TYPE_CANDY] = {
		strengthScale = 1.1,
		stamina = 25,
		price = 20,
	},
	103 = {
		strengthScale = 1.1,
		stamina = 150,
		price = 120,
	},
	201 = {
		staminaScale = 1.2,
		price = 1000,
	},
	301 = {
		staminaScale = 1.1,
		price = 100,
	},
	401 = {
		strengthScale = 1.1,
		meleeAttackScale = 1.1,
		price = 200,
	},
}

SHOP_ITEMS_INFO = {}
PICK_DAMAGE_ITEMS_INFO = {}

@{
	for(var type, item in ITEMS_INFO){
		if(item.canBuy !== false){
			SHOP_ITEMS_INFO[type] = item
		}
		if(item.pickDamage > 0){
			PICK_DAMAGE_ITEMS_INFO[type] = item
		}
	}
}


ENTITIES_INFO = {
	1 = {
	},
	2 = {
	},
	3 = {
	},
	4 = {
	},
	5 = {
	},
	6 = {
	},
	7 = {
	},
	11 = {
		fly = true,
	},
	12 = {
		fly = true,
	},
	28 = {
		fly = true,
	},
	30 = {
		fly = true,
	},
}

Game4X = extends BaseGame4X {
	__object = {
		time = 0,
		dt = 0,
		tiles = {},
		tileEnt = {},
		tileCracks = {},
		oldViewTilePosX = -1,
		oldViewTilePosY = -1,
		player = null,
		playerMaxStamina = 100,
		npcList = {},
		lightMask = null,
		following = null,
		followTileX = -1,
		followTileY = -1,
	},
	
	__construct = function(){
		super()
		@parent = stage
		@size = stage.size
		@centerViewPos = @size/2
		
		@bg = Sprite().attrs {
			resAnim = res.get("bg-start"),
			pivot = vec2(0.5, 0),
			pos = vec2(@width/2, 0),
			priority = GAME_PRIORITY_BG,
			parent = this,
		}
		@bg.scale = @width / @bg.width
		
		@view = Actor().attrs {
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			// scale = 0.7,
			priority = GAME_PRIORITY_VIEW,			
			clock = Clock(),
			parent = this,
		}
		
		@dragndrop = DragndropItems(this).attrs {
			priority = GAME_PRIORITY_DRAGNDROP,			
			parent = this,
		}
		
		@layers = []
		for(var i = 0; i < LAYER_COUNT; i++){
			@layers[] = Actor().attrs {
				priority = i,
				parent = @view,
			}
		}
		@lightMask = LightMask().attrs {
			pos = @centerViewPos,
			scale = 10.0,
			priority = GAME_PRIORITY_LIGHTMASK,
			parent = this,
		}
		@lightMask.updateDark()
		if(false)
			@lightMask.animateLight(2.5, 2, function(){
				@lightMask.animateLight(0.5, 20, function(){
					print "ligth off"			
				})
			})
		else if(false)
			@lightMask.animateLight(2.5)
		else @lightMask.animateLight(2.5)
			
		@hud = Actor().attrs {
			name = "hud",
			size = @size,
			priority = GAME_PRIORITY_HUD,
			parent = this,
			touchEnabled = false,
		}
		
		@modalView = ColorRectSprite().attrs {
			size = @size,
			color = Color(0.2, 0.23, 0.23, 0.6),
			parent = @hud,
			// touchEnabled = false,
			visible = false,
			touchEnabled = false,
			closeCallback = null,
		}
		@modalView.addEventListener(TouchEvent.CLICK, function(ev){
			ev.target == @modalView && @closeModal()
		})
		
		@hudStamina = HealthBar("stamina-border").attrs {
			name = "stamina",
			pos = vec2(1, 1),
			parent = @hud,
			value = 1,
		}
		@hudStamina.width = @playerMaxStamina * 1.0
		/* @hudStaminaNumber = TextField().attrs {
			name = "staminaNumber",
			resFont = res.get("test"),
			vAlign = TEXT_VALIGN_TOP,
			hAlign = TEXT_HALIGN_LEFT,
			x = @hudStamina.width + 3,
			text = math.round(@hudStamina.value * @playerMaxStamina),
			parent = @hudStamina,
		} */
		
		@shop = null
		
		var hudIcons = []
		/* hudIcons[] = @playerIcon = HudIcon("ent-001").attrs {
			onClicked = @openPlayer.bind(this),
			parent = @hud,
		} */
		hudIcons[] = @backpackIcon = HudIcon("backpack").attrs {
			onClicked = @openBackpack.bind(this),
			parent = @hud,
		}
		var hudIconY = @hudStamina.x + @hudStamina.height + HUD_ICON_INDENT
		for(var _, hudIcon in hudIcons){
			hudIcon.x = 2
			hudIcon.y = hudIconY
			hudIconY = hudIconY + hudIcon.height + HUD_ICON_INDENT
		}
		
		@hudSlots = []
		if(false){
			var hudSlotX = @width - 2
			for(var i = 0; i < 3; i++){
				var hudSlot = HudSlot(this, #@hudSlots).attrs {
					pivot = vec2(1, 1),
					x = hudSlotX,
					y = @height - 2,
					parent = @hud,
				}
				@hudSlots[] = hudSlot
				hudSlotX = hudSlotX - hudSlot.width - SLOT_INDENT
			}
		}else{
			var hudSlotY = 2
			// var str = _T("Use item")
			for(var i = 0; i < 3; i++){
				var hudSlot = HudSlot(this).attrs {
					pivot = vec2(1, 0),
					x = @width - 2,
					y = hudSlotY,
					parent = @hud,
				}
				@hudSlots[] = hudSlot
				hudSlotY = hudSlotY + hudSlot.height + SLOT_INDENT
			}
		}
		
		/*
		@panel = Box9Sprite().attrs {
			resAnim = res.get("panel"),
			pos = vec2(100, 100),
			size = vec2(500, 400),
			opacity = 0.8,
			priority = 17,
			parent = this,
		}
		@panel.setGuides(10, 10, 10, 10)
		*/
		
		/*
		@backpack = Backpack()
		@backpack.parent = @hud
		@backpack.pos = (@size - @backpack.size) / 2
		*/
		
		@moveJoystick = Joystick().attrs {
			// priority = GAME_PRIORITY_JOYSTICK,
			parent = @hud,
			pivot = vec2(-0.25, 1.25),
			pos = vec2(0, @height),
		}
		
		@keyPressed = {}
		if(PLATFORM == "windows"){
			var moveJoystickActivated = false
			var keyboardEvent = function(ev){
				var pressed = ev.type == KeyboardEvent.DOWN
				if(ev.scancode == KeyboardEvent.SCANCODE_LEFT || ev.scancode == KeyboardEvent.SCANCODE_A){
					@keyPressed.left = pressed
				}
				if(ev.scancode == KeyboardEvent.SCANCODE_RIGHT || ev.scancode == KeyboardEvent.SCANCODE_D){
					@keyPressed.right = pressed
				}
				if(ev.scancode == KeyboardEvent.SCANCODE_UP || ev.scancode == KeyboardEvent.SCANCODE_W){
					@keyPressed.up = pressed
				}
				if(ev.scancode == KeyboardEvent.SCANCODE_DOWN || ev.scancode == KeyboardEvent.SCANCODE_S){
					@keyPressed.down = pressed
				}
				var dx, dy = 0, 0
				if(@keyPressed.left) dx--
				if(@keyPressed.right) dx++
				if(@keyPressed.up) dy--
				if(@keyPressed.down) dy++
				if(dx != 0 || dy != 0){
					var dir = vec2(dx, dy).normalizeTo(@moveJoystick.maxLen)
					if(!moveJoystickActivated){
						moveJoystickActivated = true
						@moveJoystick.touchEnabled = false
						@moveJoystick.dispatchEvent {
							type = TouchEvent.START,
							localPosition = @moveJoystick.size/2 + dir
						}
					}else{
						@moveJoystick.dispatchEvent {
							type = TouchEvent.MOVE,
							localPosition = @moveJoystick.size/2 + dir
						}
					}
				}else if(moveJoystickActivated){
					moveJoystickActivated = false
					@moveJoystick.dispatchEvent {
						type = TouchEvent.END,
						localPosition = @moveJoystick.size/2
					}
					@moveJoystick.touchEnabled = true
				}
			}
			stage.addEventListener(KeyboardEvent.DOWN, keyboardEvent)
			stage.addEventListener(KeyboardEvent.UP, keyboardEvent)
		}

		@addUpdate(@update.bind(this))
		// @addUpdate(0.5, @checkFalling.bind(this))
		
		/* var style = TextStyle()
		style.resFont = res.get("big")
		style.vAlign = TextStyle.VALIGN_BOTTOM
		style.hAlign = TextStyle.HALIGN_CENTER */
		
		/* var text = TextField().attrs {
			resFont = res.get("normal"),
			vAlign = TextStyle.VALIGN_BOTTOM,
			hAlign = TextStyle.HALIGN_CENTER,
			// style = style,
			text = "Test text",
			// pivot = vec2(0.5, 0.5),
			pos = vec2(@width/2, @height),
			priority = 20,
			parent = this,
		} */

		
		@addEventListener(TouchEvent.CLICK, function(ev){
			if(ev.target is BaseTile){
				@pickTile(ev.target.tileX, ev.target.tileY, true)
				return
			}
			if(ev.target is NPC){
				var npc = ev.target
				if(npc.type == "trader"){
					@openShop()
				}
				return
			}
			if(ev.target is Monster){
				// print "monster clicked: ${ev.target.name}"
				return
			}
			if(ev.target is Player){
				// print "player clicked: ${ev.target.name}"
				return
			}
			// print "unknown clicked: ${ev.localPosition}"
			
			// var pos = @toLocalPos(@player)
			// var touch = ev.localPosition
		})
		
		if(false){
			var draging = null
			@addEventListener(TouchEvent.START, function(ev){
				draging = ev.localPosition
			})
			
			@addEventListener(TouchEvent.MOVE, function(ev){
				if(draging){
					var offs = ev.localPosition - draging
					@view.pos += offs
					draging = ev.localPosition
				}
			})
			
			@addEventListener(TouchEvent.END, function(ev){
				draging = null
			})
		}
		
		if(false){
		
			for(var i = 0; i < 10; i++){
				Sprite().attrs {
					resAnim = res.get("tile-01"),
					pivot = vec2(0.5, 0.5),
					pos = vec2(i*128, 300+128),
					parent = this,
				}
				Sprite().attrs {
					resAnim = res.get(sprintf("tile-%02d", math.random(2, 4))),
					pivot = vec2(0.5, 0.5),
					pos = vec2(i*128, 300+128*2),
					parent = this,
				}
				Sprite().attrs {
					resAnim = res.get(sprintf("tile-%02d", math.random(2, 4))),
					pivot = vec2(0.5, 0.5),
					pos = vec2(i*128, 300+128*3),
					parent = this,
				}
			}

			// lightMask.animateLight(1.5)
			/* lightMask.addTimeout(0.0, function(){
				var scale = 2.5
				lightMask.addTweenAction {
					duration = 3.0,
					scale = scale,
					ease = Ease.QUINT_IN,
					doneCallback = function(){
						lightMask.animateLight(scale)
					}
				}
			}) */
			/* lightMask.addAction(RepeatForeverAction(SequenceAction(
				TweenAction {
					duration = 2.0,
					scale = 2.8,
					ease = Ease.CIRC_IN_OUT,
				},
				TweenAction {
					duration = 2.0,
					scale = 1.0,
					ease = Ease.CIRC_IN_OUT,
				},
			))) */

			var monster = Monster("monster-01").attrs {
				pos = player.pos - vec2(128*2, 0),
				parent = this,
			}
			// monster.breathing(2)
			
			var monster = Monster("monster-03").attrs {
				pos = player.pos + vec2(128, 0),
				parent = this,
			}
			
			var screenBlood_01 = Sprite().attrs {
				resAnim = res.get("screen-blood-scratch"),
				priority = 1000,
				// parent = this,
				pivot = vec2(0.5, 0.5),
				pos = @size / 2,
				touchEnabled = false,
			}
			screenBlood_01.scale = @width / screenBlood_01.width
			
			var screenBlood_02 = Sprite().attrs {
				resAnim = res.get("screen-blood-breaks-01"),
				priority = 1000,
				// parent = this,
				pivot = vec2(0, 0),
				pos = vec2(0, 0),
				touchEnabled = false,
			}
			screenBlood_02.scale = @height / screenBlood_02.height
			
			var screenBlood_03 = Sprite().attrs {
				resAnim = res.get("screen-blood-breaks-02"),
				priority = 1000,
				// parent = this,
				pivot = vec2(0, 0),
				pos = vec2(0, 0),
				touchEnabled = false,
			}
			screenBlood_03.scale = @height / screenBlood_03.height
			
			var self = this
			var screenBloods = [screenBlood_01, screenBlood_02, screenBlood_03]
			
			monster.attackCallback = function(){
				// print "attackCallback"
				for(var i = 0; i < #screenBloods; i++){
					if(screenBloods[i].parent){
						// print "screenBloods[${i}].parent found"
						return
					}
				}
				if(math.random() < 0.9){
					var b = randItem(screenBloods)
					b.parent = self
					b.opacity = 1
					b.addTimeout(math.random(1, 3), function(){
						b.addTweenAction {
							duration = math.random(2, 4),
							opacity = 0,
							detachTarget = true,
						}
					})
				}
			}
			
			var attack = function(){
				player.attack(function(){
					monster.attack(-1, attack)
				})
			}
			attack()
		
		} // if(false)
		
		@initLevel(0)
		
		var screenBlood_01 = Sprite().attrs {
			resAnim = res.get("screen-blood-scratch"),
			priority = 1000,
			// parent = this,
			pivot = vec2(0.5, 0.5),
			pos = @size / 2,
			touchEnabled = false,
		}
		screenBlood_01.scale = @width / screenBlood_01.width
		
		var screenBlood_02 = Sprite().attrs {
			resAnim = res.get("screen-blood-breaks-01"),
			priority = 1000,
			// parent = this,
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			touchEnabled = false,
		}
		screenBlood_02.scale = @height / screenBlood_02.height
		
		var screenBlood_03 = Sprite().attrs {
			resAnim = res.get("screen-blood-breaks-02"),
			priority = 1000,
			// parent = this,
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			touchEnabled = false,
		}
		screenBlood_03.scale = @height / screenBlood_03.height
		
		@screenBloods = [screenBlood_01, screenBlood_02, screenBlood_03]
		
		ColorRectSprite().attrs {
			size = @size,
			color = Color.BLACK,
			priority = GAME_PRIORITY_FADEIN,
			touchEnabled = false,
			parent = this,
		}.addTweenAction {
			duration = 2.0,
			opacity = 0,
			detachTarget = true,
		}
	},
	
	createBlood = function(value){
		var allowBloods = []
		for(var i = 0; i < #@screenBloods; i++){
			if(!@screenBloods[i].parent){
				allowBloods[] = @screenBloods[i]
			}
		}
		if(#allowBloods == 0){
			return
		}
		var b = randItem(allowBloods)
		b.parent = this
		b.opacity = 1
		b.addTimeout(math.random(1, 3), function(){
			b.addTweenAction {
				duration = math.random(2, 4),
				opacity = 0,
				detachTarget = true,
			}
		})
	},
	
	cleanupActor = function(actor){
		"cleanup" in actor && actor.cleanup()
		for(var _, child in actor.childrenList){
			@cleanupActor(child)
		}
	},
	
	closeModal = function(){
		if(@modalView.visible){
			@view.clock.resume()
			@modalView.visible = false
			@modalView.touchEnabled = false
			@cleanupActor(@modalView)
			@modalView.removeChildren()
			var closeCallback = @modalView.closeCallback
			closeCallback() // use callback's this instead of @modalView
			@modalView.closeCallback = null
		}
	},
	
	openModal = function(window, closeCallback){
		@closeModal()
		@modalView.visible = true
		@modalView.touchEnabled = true
		@view.clock.pause()
		
		@moveJoystick.visible = false
		@modalView.closeCallback = function(){
			@moveJoystick.visible = true
			closeCallback()
		}
		
		window.parent = @modalView
		window.pos = (@size - window.size) / 2
		window.runTutorial()
	},
	
	openShop = function(){
		// @playerIcon.touchEnabled = false
		@shop = Shop(this)
		@openModal(@shop, function(){
			// @playerIcon.touchEnabled = true
			@shop = null
		})
	},
	
	openBackpack = function(){
		@backpackIcon.touchEnabled = false
		@openModal(Backpack(this), function(){
			@backpackIcon.touchEnabled = true
		})
	},
	
	updateHudItems = function(){
		for(var _, slot in @hudSlots){
			slot.updateItem()
		}
	},
	
	initLevel = function(num){
		var filenames = require("levels")
		var names = filenames.keys
		var filename = filenames[names[@levelNum = num % #names]]
		var level = json.decode(File.readContents(filename))
		var data = zlib.gzuncompress(File.readContents(filename.replace(".json", ".bin")))
		var dataPrefix = LEVEL_BIN_DATA_PREFIX
		print "level: "..typeOf(level)
		print "data len: ${#data}, prefix: ${data.sub(0, #dataPrefix) == dataPrefix}"
		data.sub(0, #dataPrefix) == dataPrefix || throw "level data corrupted"
		// data = data.sub(#dataPrefix)
		
		@tiledmapWidth = level.width
		@tiledmapHeight = level.height
		@tiledmapFloor = level.floor
		
		@registerLevelInfo(@tiledmapWidth, @tiledmapHeight, data)
		
		for(var _, obj in level.groups.entities.objects){
			@addTiledmapEntity(obj) // .x, obj.y, obj.gid, obj.type)
		}
	},

	toLocalPos = function(child, pos){
		return child.localToGlobal(pos || vec2(0, 0), this)
	},
	
	initEntTile = function(ent, tx, ty){
		DEBUG && assert(!@tileEnt["${tx}-${ty}"])
		ent.tileX, ent.tileY = tx, ty
		ent.pos = @tileToCenterPos(tx, ty)
		@tileEnt["${tx}-${ty}"] = ent
	},
	
	setEntTile = function(ent, tx, ty){
		if(ent.tileX != tx || ent.tileY != ty){
			var key = "${ent.tileX}-${ent.tileY}"
			DEBUG && assert(@tileEnt[key] === ent, "tile busy at ${ent.tileX}x${ent.tileY} by ${@tileEnt[key].tileX}x${@tileEnt[key].tileY}")
			delete @tileEnt[key]
			ent.prevTileX, ent.prevTileY = ent.tileX, ent.tileY
			ent.tileX, ent.tileY = tx, ty
			@tileEnt["${tx}-${ty}"] = ent
		}
	},
	
	unsetEntTile = function(ent){
		var key = "${ent.tileX}-${ent.tileY}"
		DEBUG && assert(@tileEnt[key] === ent)
		delete @tileEnt[key]
		ent.tileX, ent.tileY = -1, -1
	},
	
	getTileEnt = function(tx, ty){
		return @tileEnt["${tx}-${ty}"]
	},
	
	getAutoFrontType = function(tx, ty){
		var tile = @getTile(tx, ty)
		tile.openState > 0.7 && return TILE_TYPE_EMPTY
		return @getFrontType(tx, ty)
	},
	
	pickTile = function(tx, ty, byTouch){
		if(math.abs(@player.tileX - tx) > 1 || math.abs(@player.tileY - ty) > 1){
			return
		}
		var tile = @getTile(tx, ty)
		var type = @getAutoFrontType(tx, ty)
		var tileInfo = TILES_INFO[type]
		if(!tileInfo.strength){
			tile.pickByEnt(@player)
			return
		}
		Player.pickItemType || return;
		var itemInfo = ITEMS_INFO[tile.itemType]
		var damage = ITEMS_INFO[Player.pickItemType].pickDamage || 1
		var deepStrength = math.abs(ty - @tiledmapFloor) / 15
		var strength = math.round(((tileInfo.strength || 3) + deepStrength) 
				* (itemInfo.strengthScale || 1) / damage)
		if(strength > 15){
			print "tile ${tx}x${ty} too strength: ${strength}, deep: ${math.round(deepStrength, 2)}, damage: ${damage}"
			tile.pickByEnt(@player)
			return
		}
		var key = "${tx}-${ty}"
		var crack = @tileCracks[key] || @{
			var pos = @tileToCenterPos(tx, ty)
			var crack = Sprite().attrs {
				resAnim = res.get("crack"),
				pivot = vec2(0.5, 0.5),
				pos = pos,
				opacity = 0.8,
				priority = ty * @tiledmapWidth + tx,
				// tileX = tx,
				// tileY = ty,
				// tileType = type,
				touchEnabled = false,
				parent = @layers[LAYER_DECALS],
				damageDelay = tileInfo.damageDelay || 0.3,
				strength = strength, 
				damage = -1,				
				nextDamageTime = 0,
			}
			if(@player.tileX > tx){
				crack.angle = 0
			}else if(@player.tileX < tx){
				crack.angle = 90*2
			}else if(@player.tileY > ty){
				crack.angle = 90*1
			}else if(@player.tileY < ty){
				crack.angle = 90*3
			}
			crack.scaleY = math.random() < 0.5 ? -1 : 1
			@tileCracks[key] = crack
			return crack
		}
		// print "tile ${tx}x${ty} strength: ${crack.damage+1}/${strength} , deep: ${math.round(deepStrength, 2)}, damage: ${damage}"
		if(byTouch || crack.nextDamageTime <= @time){
			if(++crack.damage >= crack.strength-1){
				delete @tileCracks[key]; crack.detach()
				@setFrontType(tx, ty, TILE_TYPE_EMPTY)
				if(tile.itemType != ITEM_TYPE_EMPTY){
					@getTileItem(tile.itemType, tx, ty)
				}
				@removeTile(tx, ty)
				@updateTile(tx, ty)
				@updateTiledmapShadowViewport(tx-1, ty-1, tx+1, ty+1)
				return true
			}
			crack.nextDamageTime = @time + crack.damageDelay
			@player.useStaminaByCrack()
		}
		crack.resAnimFrameNum = (crack.damage+1) * crack.resAnim.totalFrames / crack.strength
		return true
	},
	
	getTileItem = function(type, tx, ty){
		if(Backpack.addItem(type)){
			@setItemType(tx, ty, ITEM_TYPE_EMPTY)
			@backpackIcon.scale = 1
			var action = EaseAction(TweenAction {
				duration = 0.5,
				scale = 1.2,
				ease = Ease.PING_PONG
			}, Ease.CUBIC_IN_OUT)
			action.name = "note"
			@backpackIcon.replaceAction(action)
			return true
		}else{
			@backpackIcon.color = Color.WHITE
			@backpackIcon.replaceTweenAction {
				name = "note",
				duration = 0.5,
				color = Color(1, 0, 0),
				ease = Ease.PING_PONG
			}
		}
	},
	
	getTileRandom = function(x, y, a, b){
		var r = super(x, y)
		if(b){
			return r * (b - a) + a
		}
		if(a){
			return math.round(r * (a-1))
		}
		return r
	},
	
	getTileRandomInt = function(x, y, a, b){
		return math.round(@getTileRandom(x, y, a, b))
	},
	
	getResName = function(group, i, j){
		if(j){
			return sprintf("${group}-%03d-%02d", i, j)
		}
		return sprintf("${group}-%03d", i)
	},
	
	getTileResName = function(group, i, x, y, b){
		b && return @getResName(group, i, @getTileRandomInt(x, y, 1, b))
		// x && return @getResName(group, i, x)
		return @getResName(group, i)
	},
	
	getSlotItemResName = function(type){
		return @getResName("slot-item", type)
	},
	
	getTileItemResName = function(type, x, y){
		var info = ITEMS_INFO[type] || throw "item ${type} not found"
		if(info.hasTileSprite){
			return @getTileResName("tile-item", type, x, y, info.variants)
		}
		return @getSlotItemResName(type)
	},
	
	getTile = function(x, y){
		return @tiles["${x}-${y}"]
	},
	
	touchGroupRes = function(group, type){
		var variants = null
		if(group == "tile-item" && ITEMS_INFO[type].hasTileSprite){
			variants = ITEMS_INFO[type].variants
		}else if(group == "tile"){
			variants = TILES_INFO[type].variants
		}else if(group == "slot-item"){
		}else{
			throw "unknown group ${group}"
		}
		if(variants){
			for(var i = 1; i <= variants; i++){
				res.get(@getResName(group, type, i))
			}
		}else
			res.get(@getResName(group, type))
	},
	
	touchTileRes = function(type){
		@touchGroupRes("tile", type)
	},
	
	touchItemRes = function(type){
		if(type != 0){
			@touchGroupRes("tile-item", type)
			@touchGroupRes("slot-item", type)
		}
	},
	
	updateTile = function(x, y){
		var tile = @getTile(x, y)
		if(!tile){
			var type = @getFrontType(x, y)
			tile = _G[TILES_INFO[type].class || "Tile"](this, x, y)
			// tile = Tile(this, x, y)
		}
		tile.time = @time
	},
	
	updateTiledmapShadowViewport = function(ax, ay, bx, by){
		for(var y = ay; y <= by; y++){
			for(var x = ax; x <= bx; x++){
				var tile = @getTile(x, y)
				tile.updateShadow()
			}
		}
	},
	
	updateTiledmapViewport = function(ax, ay, bx, by){
		for(var y = ay; y <= by; y++){
			for(var x = ax; x <= bx; x++){
				@updateTile(x, y)
			}
		}
		@updateTiledmapShadowViewport(ax, ay, bx, by)
	},
	
	playerDead = function(){
		Player.pickItemType = null
		Backpack.pack.items = {}
		Backpack.pack.updateNumItems()
		@updateHudItems()
		
		@player.reset()
		
		// @cleanupActor(@player)
		// @player.detach()
		// @player = Player(this, Player.saveName)
		@unsetEntTile(@player)
		@initEntTile(@player, Player.saveTileX, Player.saveTileY)
		@centerViewToTile(Player.saveTileX, Player.saveTileY)
	},
	
	addTiledmapEntity = function(obj){ // x, y, type, isPlayer){
		if(obj.type == "player"){
			@player && throw "player is already exist"
			@player = Player(this, obj.gid)
			@initEntTile(@player, obj.x, obj.y)
			@centerViewToTile(obj.x, obj.y)
			
			Player.saveName = obj.gid
			Player.saveTileX = obj.x
			Player.saveTileY = obj.y
			return
		}
		if(obj.type == "trader"){
			var npc = NPC(this, obj.gid, obj.type)
			@npcList[npc] = npc
			@initEntTile(npc, obj.x, obj.y)
			npc.createPatrolAreaIfNecessary()
			return
		}
		if(obj.gid > 0){
			var monster = Monster(this, obj.gid)
			@initEntTile(monster, obj.x, obj.y)
			monster.createPatrolAreaIfNecessary()
			return
		}
		throw "unknown entity tiledmap type: ${obj.gid}"
	},
	
	removeTile = function(tx, ty){
		var key = "${tx}-${ty}"
		var tile = @tiles[key]
		if(tile){
			delete @tiles[key]
			tile.detach()
		}
	},
	
	markTileVisibility = function(tile, visible){
		if(!visible){
			// print "DELETE tile ${tile.tileX}x${tile.tileY}, type: ${tile.tileType}, name: ${tile.resAnim.name}"
			delete @tiles["${tile.tileX}-${tile.tileY}"]
			tile.detach()
		}
	},
	
	markEntVisibility = function(ent, visible){
		
	},
	
	centerViewToTile = function(tx, ty){
		var pos = @tileToCenterPos(tx, ty) - @centerViewPos / @view.scale
		@view.pos = -pos * @view.scale
		@updateView()
	},
	
	followPlayer = function(){
		// if(!@following){
			var tx, ty = @posToTile(@player.pos) // @player.tileX, @player.tileY
			if(@followTileX != tx || @followTileY != ty){
				@followTileX, @followTileY = tx, ty
				var pos = -(@tileToCenterPos(tx, ty) - @centerViewPos / @view.scale) * @view.scale
				@following = @view.replaceTweenAction {
					name = "following",
					duration = 0.6,
					pos = pos,
					doneCallback = function(){
						@following = false
					},
				}
			}
		// }else{
		if(@following){
			@updateView()
		}
		var pos = @toLocalPos(@player, @player.size/2)
		@lightMask.pos = pos
		@lightMask.updateDark()
	},
	
	tileToCenterPos = function(x, y){
		return vec2((x + 0.5) * TILE_SIZE, (y + 0.5) * TILE_SIZE)
	},
	
	tileToPos = function(x, y){
		return vec2(x * TILE_SIZE, y * TILE_SIZE)
	},
	
	posToTile = function(pos){
		return math.floor(pos.x / TILE_SIZE), math.floor(pos.y / TILE_SIZE)
	},
	
	posToCeilTile = function(pos){
		return math.ceil(pos.x / TILE_SIZE), math.ceil(pos.y / TILE_SIZE)
	},
	
	posToRoundTile = function(pos){
		return math.round(pos.x / TILE_SIZE), math.round(pos.y / TILE_SIZE)
	},
	
	updateView = function(){
		var offs = -@view.pos / @view.scale
		var startX, startY = @posToTile(offs)
		if(startX != @oldViewTilePosX || startY != @oldViewTilePosY){
			@oldViewTilePosX, @oldViewTilePosY = startX, startY
			
			var endOffs = offs + @size / @view.scale
			var endX, endY = @posToCeilTile(endOffs)
			
			@updateTiledmapViewport(startX, startY, endX, endY)
			
			for(var i, layer in @layers){
				if(i == LAYER_TILES){
					for(var _, tile in layer){
						@markTileVisibility(tile, tile.time == @time)
					}
				}
			}
			// print "alive tiles: ${#@layers[LAYER_TILES]}"
		}
	},
	
	update = function(ev){
		@time, @dt = ev.time, ev.dt
		/* if(@moveJoystick.active){
			@player.moveDir = @moveJoystick.dir
		}else{
			@player.moveDir = vec2(0, 0)
		} */
		// @player.update(ev)
		/* for(var i, layer in @layers){
			for(var _, obj in layer){
				"update" in obj && obj.update()
			}
		} */
		@followPlayer()
	},
	
	/* checkFalling = function(){
		var tx, ty = @player.tileX, @player.tileY
		var type = @getFrontType(tx, ty - 1)
		if(type == TILE_TYPE_ROCK){
			var tile = @getTile(tx, ty)
			if(!(tile is Door)){
				type = @getFrontType(tx, ty + 1)
				if(type != TILE_TYPE_EMPTY){
					var tile = @getTile(tx, ty - 1)
					tile.startFalling()
				}
			}
		}
	}, */
}