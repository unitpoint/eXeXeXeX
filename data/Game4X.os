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
LAYER_EXPLODES = enumCount++
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
GAME_PRIORITY_GLOWING = 4
GAME_PRIORITY_BUBBLES = 5
GAME_PRIORITY_HUD = 6
GAME_PRIORITY_DRAGNDROP = 7
GAME_PRIORITY_MODALVIEW = 8
GAME_PRIORITY_BLOOD = 9
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
		glowing = true,
	},
	3 = {
		strength = 30,
		glowing = true,
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
ITEM_TYPE_SHOVEL = 16
ITEM_TYPE_PICK_01 = 17
ITEM_TYPE_PICK_02 = 18
ITEM_TYPE_PICK_03 = 19
ITEM_TYPE_BULLETS = 21
ITEM_TYPE_LADDERS = 23
ITEM_TYPE_STAMINA = 24
ITEM_TYPE_FOOD_01 = 25
ITEM_TYPE_FOOD_02 = 26
ITEM_TYPE_FOOD_03 = 27
ITEM_TYPE_BOMB_01 = 32
ITEM_TYPE_BOMB_02 = 33
ITEM_TYPE_BOMB_03 = 34
ITEM_TYPE_BOMB_04 = 35
ITEM_TYPE_STAND_FLAME_01 = 40

// not real items
ITEM_TYPE_SHOPPING = 1000

ITEMS_INFO = {
	1 = {
		hasTileSprite = true,
		strengthScale = 1.1,
		price = 50,
		canBuy = false,
		glowing = true,
	},
	2 = {
		hasTileSprite = true,
		strengthScale = 1.15,
		price = 75,
		canBuy = false,
		glowing = true,
	},
	3 = {
		hasTileSprite = true,
		strengthScale = 1.2,
		price = 85,
		canBuy = false,
		glowing = true,
	},
	4 = {
		hasTileSprite = true,
		strengthScale = 1.1,
		price = 60,
		canBuy = false,
		glowing = true,
	},
	5 = {
		hasTileSprite = true,
		strengthScale = 1.1,
		price = 95,
		canBuy = false,
		glowing = true,
	},
	6 = {
		hasTileSprite = true,
		strengthScale = 1.1,
		price = 155,
		canBuy = false,
		glowing = true,
	},
	[ITEM_TYPE_COAL] = {
		hasTileSprite = true,
		strengthScale = 1.5,
		price = 35,
		canBuy = false,
		glowing = true,
	},
	8 = {
		hasTileSprite = true,
		strengthScale = 1.1,
		price = 45,
		canBuy = false,
		glowing = true,
	},
	9 = {
		hasTileSprite = true,
		strengthScale = 1.5,
		price = 190,
		canBuy = false,
		glowing = true,
	},
	[ITEM_TYPE_GOLD] = {
		hasTileSprite = true,
		variants = 2,
		strengthScale = 2,
		price = 100,
		canBuy = false,
		glowing = true,
	},
	[ITEM_TYPE_SHOVEL] = {
		strengthScale = 1.1,
		price = 100,
		pickDamage = 1,
	},
	[ITEM_TYPE_PICK_01] = {
		strengthScale = 2,
		price = 1500,
		pickDamage = 3,
	},
	[ITEM_TYPE_PICK_02] = {
		strengthScale = 4,
		price = 5000,
		pickDamage = 6,
	},
	[ITEM_TYPE_PICK_03] = {
		strengthScale = 6,
		price = 10000,
		pickDamage = 12,
	},
	[ITEM_TYPE_BULLETS] = {
		strengthScale = 1.1,
		price = 1,
		canBuy = false,
	},
	[ITEM_TYPE_LADDERS] = {
		strengthScale = 1.1,
		price = 20,
		// useDistance = 1,
	},
	[ITEM_TYPE_STAMINA] = {
		addMaxStamina = 25,
		strengthScale = 4,
		price = 1000,
		useSounds = ["max-stamina"],
	},
	[ITEM_TYPE_FOOD_01] = {
		strengthScale = 1.1,
		stamina = 25,
		price = 25,
		useSounds = ["item-04"],
	},
	[ITEM_TYPE_FOOD_02] = {
		strengthScale = 1.2,
		stamina = 100,
		price = 100,
		useSounds = ["item-04"],
	},
	[ITEM_TYPE_FOOD_03] = {
		strengthScale = 1.3,
		stamina = 200,
		price = 150,
		useSounds = ["item-04"],
	},
	[ITEM_TYPE_BOMB_01] = {
		strengthScale = 1.5,
		price = 100,
		bomb = true,
		explodeRadius = 1.0,
		explodeWait = 3.0,
		damage = 200,
		useDistance = 1,
		useSounds = ["grenade-bounce-01", "grenade-bounce-02"],
	},
	[ITEM_TYPE_BOMB_02] = {
		strengthScale = 1.5,
		price = 200,
		bomb = true,
		explodeRadius = 1.5,
		explodeWait = 3.0,
		damage = 500,
		useDistance = 2,
		useSounds = ["grenade-bounce-01", "grenade-bounce-02"],
	},
	[ITEM_TYPE_BOMB_03] = {
		strengthScale = 2.0,
		price = 300,
		bomb = true,
		explodeRadius = 2.0,
		explodeWait = 3.0,
		damage = 1500,
		useDistance = 3,
		useSounds = ["grenade-bounce-01", "grenade-bounce-02"],
	},
	[ITEM_TYPE_BOMB_04] = {
		strengthScale = 2.5,
		price = 500,
		bomb = true,
		explodeRadius = 2.9,
		explodeWait = 3.0,
		damage = 5000,
		useDistance = 3,
		useSounds = ["grenade-bounce-01", "grenade-bounce-02"],
	},
	[ITEM_TYPE_STAND_FLAME_01] = {
		strengthScale = 2.0,
		price = 300,
		canBuy = false,
		// useDistance = 3,
	},
	/*
	301 = {
		staminaScale = 1.1,
		price = 100,
	},
	[ITEM_TYPE_WEAPON_01] = {
		strengthScale = 1.5,
		meleeAttack = 20,
		price = 200,
	},
	*/
}

SHOP_ITEMS_INFO = {}
PICK_DAMAGE_ITEMS_INFO = {}
BOMB_ITEMS_INFO = {}
// LADDERS_ITEMS_INFO = {}

@{
	// LADDERS_ITEMS_INFO[ITEM_TYPE_LADDERS] = ITEMS_INFO[ITEM_TYPE_LADDERS]
	
	for(var type, item in ITEMS_INFO){
		if(item.canBuy !== false){
			SHOP_ITEMS_INFO[type] = item
		}
		if(item.pickDamage > 0){
			PICK_DAMAGE_ITEMS_INFO[type] = item
		}
		if(item.explodeRadius > 0){
			BOMB_ITEMS_INFO[type] = item
		}
	}
}

PLAYER_START_HEALTH = 200
PLAYER_MAX_HEALTH = 800

ENTITIES_INFO = {
	1 = {
	},
	2 = {
	},
	3 = {
		class = "Player",
		// player = true,
	},
	4 = {
	},
	5 = {
	},
	6 = {
	},
	7 = {
	},
	8 = {
		attack = 170,
	},
	9 = {
		attack = 150,
	},
	10 = {
		attack = 50,
	},
	11 = {
		attack = 3000,
		fly = true,
	},
	12 = {
		attack = 5000,
		fly = true,
	},
	13 = {
		attack = 30,
	},
	14 = {
		attack = 100,
	},
	15 = {
		attack = 400,
	},
	16 = {
		attack = 700,
	},
	17 = {
		attack = 200,
	},
	18 = {
		attack = 2000,
	},
	19 = {
		attack = 100,
	},
	20 = {
		attack = 150,
	},
	21 = {
		attack = 50,
	},
	22 = {
		attack = 500,
	},
	23 = {
		attack = 90,
	},
	24 = {
		attack = 110,
	},
	25 = {
		attack = 120,
	},
	26 = {
		attack = 300,
	},
	27 = {
		attack = 1000,
		spyder = true,
	},
	28 = {
		attack = 2000,
		fly = true,
	},
	29 = {
		attack = 2500,
		spyder = true,
	},
	30 = {
		attack = 5000,
		fly = true,
	},
	31 = {
		attack = 500,
		spyder = true,
	},
	32 = {
		attack = 80,
	},
	33 = {
		attack = 60,
	},
	34 = {
		attack = 110,
	},
	35 = {
		attack = 210,
	},
	36 = {
		attack = 450,
	},
	37 = {
		attack = 190,
	},
	43 = {
		class = "NPC_Trader",
		// trader = true,
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
		// playerMaxStamina = 300,
		// playerStamina = 0,
		// npcList = {},
		lightMask = null,
		following = null,
		followTileX = -1,
		followTileY = -1,
	},
	
	__construct = function(saveSlotNum){
		super()
		@saveSlotNum = saveSlotNum // GAME_SETTINGS.saveSlots[saveSlotNum] ? saveSlotNum : null// || 0
		// @levelNum = null // levelNum || 0
		@parent = stage
		@size = stage.size
		@centerViewPos = @size/2
		
		// @shakeOffs = vec2(0, 0)
		@shakeUpdateHandle = null
		
		@blockSound = null
		@blockSoundTime = 0
		
		@digSound = null
		@digSoundTime = 0
		
		@rockBreakSound = null
		@rockBreakSoundTime = 0
		
		@checkBombBubbleTime = 0
		
		@bg = Sprite().attrs {
			resAnim = res.get("bg-start"),
			pivot = vec2(0.5, 0),
			pos = vec2(@width/2, 0),
			priority = GAME_PRIORITY_BG,
			parent = this,
		}
		@bg.scale = @width / @bg.width
		
		@glowingTiles = Actor().attrs {
			priority = GAME_PRIORITY_GLOWING,
			touchEnabled = false,
			touchChildrenEnabled = false,
			parent = this,
		}
		
		@speechBubbles = Actor().attrs {
			priority = GAME_PRIORITY_BUBBLES,
			touchEnabled = false,
			// touchChildrenEnabled = false,
			parent = this,
		}
		
		// var game = this
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
		
		@lightLayer = BaseLightLayer().attrs {
			size = @size,
			priority = GAME_PRIORITY_LIGHTMASK,
			parent = this,
		}
		
		@hud = Actor().attrs {
			name = "hud",
			size = @size,
			priority = GAME_PRIORITY_HUD,
			parent = this,
			touchEnabled = false,
		}
		
		@modalView = ModalView().attrs {
			name = "modalView",
			size = @size,
			parent = @hud,
			// touchEnabled = false,
			visible = false,
			touchEnabled = false,
			closeCallback = null,
		}
		@saveSlotNum && @modalView.addEventListener(TouchEvent.CLICK, function(ev){
			if(ev.target == @modalView){
				@closeModal()
				playMenuClickSound()
			}
		})
		
		@hudStamina = HealthBar("stamina-border").attrs {
			name = "stamina",
			pos = vec2(1, 1),
			// width = @playerMaxStamina * 1.0,
			// height = 14,
			parent = @hud,
			value = 1,
			visible = false
		}
		// @hudStamina.width = @playerMaxStamina * 1.0
		// @playerStamina = @playerMaxStamina
		
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
		hudIcons[] = @saveGameIcon = HudIcon("save").attrs {
			// onClicked = @saveGame.bind(this),
			onClicked = @openSaveGame.bind(this),
			parent = @hud,
		}
		hudIcons[] = @loadGameIcon = HudIcon("load").attrs {
			// onClicked = @reloadGame.bind(this),
			onClicked = @openLoadGame.bind(this),
			parent = @hud,
		}
		var hudIconY = @hudStamina.x + @hudStamina.height + HUD_ICON_INDENT
		for(var _, hudIcon in hudIcons){
			hudIcon.x = 2
			hudIcon.y = hudIconY
			hudIconY = hudIconY + hudIcon.height + HUD_ICON_INDENT
		}
		@disableSaveLoad()
		
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
		
		@moveJoystick = Joystick().attrs {
			// priority = GAME_PRIORITY_JOYSTICK,
			parent = @hud,
			pivot = vec2(-0.25, 1.25),
			pos = vec2(0, @height),
		}
		
		@keyPressed = {}
		@keyEventDownId = @keyEventUpId = null
		if(PLATFORM == "windows" && @saveSlotNum){
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
			@keyEventDownId = stage.addEventListener(KeyboardEvent.DOWN, keyboardEvent)
			@keyEventUpId = stage.addEventListener(KeyboardEvent.UP, keyboardEvent)
		}

		@addUpdate(@update.bind(this))
		
		@saveSlotNum && @addEventListener(TouchEvent.CLICK, function(ev){
			if(ev.target is BaseTile){
				@pickTile(ev.target.tileX, ev.target.tileY, true)
				return
			}
			if(ev.target is NPC_Trader){
				/* var npc = ev.target
				if(npc.typeName == "trader"){
					@openShop()
				} */
				@openShop()
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
		
		@dragging = null
		if(@saveSlotNum){
			@addEventListener(TouchEvent.START, function(ev){
				if(ev.target is BaseTile){
					@dragging = ev.localPosition
				}
			})
			
			@addEventListener(TouchEvent.MOVE, function(ev){
				if(@dragging){
					var offs = ev.localPosition - @dragging
					@view.pos += offs
					@glowingTiles.pos = @speechBubbles.pos = @view.pos
					@dragging = ev.localPosition
				}
			})
			
			@addEventListener(TouchEvent.END, function(ev){
				@dragging = null
			})
		}
		
		@hudBlood = Actor().attrs {
			priority = GAME_PRIORITY_BLOOD,
			touchEnabled = false,
			touchChildrenEnabled = false,
			parent = this,
		}
		
		var screenBlood_01 = Sprite().attrs {
			resAnim = res.get("screen-blood-scratch"),
			// priority = 1000,
			// parent = this,
			pivot = vec2(0.5, 0.5),
			pos = @size / 2,
			// touchEnabled = false,
		}
		screenBlood_01.scale = @width / screenBlood_01.width
		
		var screenBlood_02 = Sprite().attrs {
			resAnim = res.get("screen-blood-breaks-01"),
			// priority = 1000,
			// parent = this,
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			// touchEnabled = false,
		}
		screenBlood_02.scale = @height / screenBlood_02.height
		
		var screenBlood_03 = Sprite().attrs {
			resAnim = res.get("screen-blood-breaks-02"),
			// priority = 1000,
			// parent = this,
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			// touchEnabled = false,
		}
		screenBlood_03.scale = @height / screenBlood_03.height
		
		@screenBloodAnim_01 = Sprite().attrs {
			resAnim = res.get("screen-blood-anim-01"),
			priority = 1000,
			// parent = this,
			pivot = vec2(0, 0),
			// pos = vec2(0, 0),
			// touchEnabled = false,
		}
		var scale = @height / @screenBloodAnim_01.height * 0.7
		@screenBloodAnim_01.scale = scale
		@screenBloodAnim_01.size = @screenBloodAnim_01.size * scale
		
		@screenBloods = [screenBlood_01, screenBlood_02, screenBlood_03, @screenBloodAnim_01]
		
		@initLevel()
		if(!@saveSlotNum){
			@hud.visible = false
			@player.visible = false
			@modalView.parent = this
			@modalView.priority = GAME_PRIORITY_MODALVIEW
			@modalView.color = Color(0.2, 0.23, 0.23, 0),
			@openLoadGame()
			playMusic("music-menu")
		}else{
			playMusic("music", 0.3)
		}
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
		b.parent = @hudBlood
		b.opacity = 1
		if(b === @screenBloodAnim_01){
			b.pos = vec2(
						math.random(b.width * 0.5, @width - b.width * 1.5), 
						math.random(b.height * 0.5, @height - b.height * 1.5))
			b.resAnimFrameNum = 0
		}
		b.addTimeout(math.random(1, 3), function(){
			if(b === @screenBloodAnim_01){
				var delay = 0.2
				var handle = b.addUpdate(delay, function(){
					// print "cur frame: ${b.resAnimFrameNum}"
					var saveSize = b.size
					b.resAnimFrameNum = (b.resAnimFrameNum + 1) % b.resAnim.totalFrames
					b.size = saveSize
					
					if(b.resAnimFrameNum == 0){
						b.removeUpdate(handle)
						b.removeAction(action)
						b.detach()
					}else{
						// var saveSize = b.size, b.scale
						// b.size, b.scale = saveSize, saveScale
					}
				})
				var action = b.addTweenAction {
					duration = (b.resAnim.totalFrames * 1.0) * delay,
					opacity = 0,
					// detachTarget = true,
				}
				return
			}

			b.addTweenAction {
				duration = math.random(2, 4),
				opacity = 0,
				detachTarget = true,
			}
		})
	},
	
	traverseActor = function(actor, methodName){
		for(var _, child in actor.childrenList){
			@traverseActor(child, methodName)
		}
		methodName in actor && actor[methodName]()
	},
	
	cleanupActor = function(actor){
		@traverseActor(actor, "cleanup")
	},
	
	pauseActor = function(actor){
		@traverseActor(actor, "pause")
	},
	
	resumeActor = function(actor){
		@traverseActor(actor, "resume")
	},
	
	closeModal = function(){
		if(@modalView.visible){
			@cleanupActor(@modalView)
			@modalView.visible = false
			@modalView.touchEnabled = false
			@modalView.removeChildren()
			var closeCallback = @modalView.closeCallback
			@modalView.closeCallback = null

			if(@modalView.pauseGame){
				@view.clock.resume()
				@resumeActor(@view)
			}
			
			closeCallback() // use callback's this instead of @modalView
		}
	},
	
	openModal = function(window, closeCallback){
		@closeModal()
		
		@modalView.pauseGame = !!@saveSlotNum
		if(@modalView.pauseGame){
			@view.clock.pause()
			@pauseActor(@view)
		}
		
		@modalView.visible = true
		@modalView.touchEnabled = true
		
		@moveJoystick.visible = false
		@modalView.closeCallback = function(){
			@moveJoystick.visible = true
			closeCallback()
		}
		
		window.parent = @modalView
		window.pos = (@size - window.size) / 2
		"runTutorial" in window && window.runTutorial()
	},
	
	openShop = function(){
		playMenuClickSound()
		// @playerIcon.touchEnabled = false
		@shop = Shop(this)
		@openModal(@shop, function(){
			// @playerIcon.touchEnabled = true
			@shop = null
		})
	},
	
	openBackpack = function(){
		playMenuClickSound()
		@backpackIcon.touchEnabled = false
		@openModal(Backpack(this), function(){
			@backpackIcon.touchEnabled = true
		})
	},
	
	openLoadGame = function(){
		playMenuClickSound()
		@loadGameIcon.touchEnabled = false
		@openModal(LoadGame(this), function(){
			@loadGameIcon.touchEnabled = true
		})
	},
	
	openSaveGame = function(){
		playMenuClickSound()
		@saveGameIcon.touchEnabled = false
		@openModal(SaveGame(this), function(){
			@saveGameIcon.touchEnabled = true
		})
	},
	
	enableSaveLoad = function(){
		@saveGameIcon.visible = @loadGameIcon.visible = true
	},
	
	disableSaveLoad = function(){
		@saveGameIcon.visible = @loadGameIcon.visible = false
	},
	
	updateHudItems = function(){
		for(var _, slot in @hudSlots){
			slot.updateItem()
		}
	},
	
	hasHudItem = function(type){
		for(var _, slot in @hudSlots){
			slot.type == type && return true
		}
	},
	
	initLevel = function(){
		if(@saveSlotNum){
			var saveSlot = GAME_SETTINGS.saveSlots[@saveSlotNum]
			var levelNum = saveSlot.levelNum || 1
			var xor = saveSlot.xor || 0
		}else{
			var levelNum, xor = 0, 0
		}
		if(!saveSlot){
			Player.bullets = 0
			Player.pickItemType = null
			Player.pickItemUsage = {}
			Backpack.initPack()
		}
		var filenames = require("levels")
		var names = filenames.keys
		var filename = filenames[names[levelNum]] // = @levelNum % #names]]
		
		var jsonData = File.readContents(filename)
		@levelJsonCRC = hashlib.crc32(jsonData)
		var level = json.decode(jsonData)
		
		var data = File.readContents(filename.replace(".json", ".bin"))
		@levelDataCRC = hashlib.crc32(data)
		var data = zlib.gzuncompress(data)
		
		var dataPrefix = LEVEL_BIN_DATA_PREFIX
		print "level: "..typeOf(level)
		print "data len: ${#data}, prefix: ${data.sub(0, #dataPrefix) == dataPrefix}"
		data.sub(0, #dataPrefix) == dataPrefix || throw "level data corrupted"
		// data = data.sub(#dataPrefix)
		
		@tiledmapWidth = level.width
		@tiledmapHeight = level.height
		@tiledmapFloor = level.floor
		
		// load
		var saveJsonFilename = "save-${@saveSlotNum}-${levelNum}-${xor}.json"
		var loaded = saveSlot && File.exists(saveJsonFilename) && @{
			var notLoaded = function(str){
				print "[saved game (${saveJsonFilename}) error] ${str}"
				return false
			}
			try{
				var levelSave = json.decode(File.readContents(saveJsonFilename))
				levelSave.jsonCRC == @levelJsonCRC || return notLoaded("jsonCRC")
				levelSave.dataCRC == @levelDataCRC || return notLoaded("dataCRC")
				
				var data = zlib.gzuncompress(File.readContents(saveJsonFilename.replace(".json", ".bin")))
				var dataPrefix = LEVEL_BIN_DATA_PREFIX
				print "levelSave: "..typeOf(levelSave)
				print "data len: ${#data}, prefix: ${data.sub(0, #dataPrefix) == dataPrefix}"
				data.sub(0, #dataPrefix) == dataPrefix || return notLoaded("dataPrefix") // throw "save level data corrupted"
				// data = data.sub(#dataPrefix)
				
				@tiledmapWidth == levelSave.width || return notLoaded("tiledmapWidth") // throw "save level corrupted"
				@tiledmapHeight == levelSave.height || return notLoaded("tiledmapHeight") // throw "save level corrupted"
				@tiledmapFloor == levelSave.floor || return notLoaded("tiledmapFloor") // throw "save level corrupted"
				
				@loadGameState(levelSave.state)
				@registerLevelData(@tiledmapWidth, @tiledmapHeight, data)
				for(var _, obj in levelSave.entities){
					@addTiledmapEntity(obj, obj.state) // .x, obj.y, obj.gid, obj.type)
				}
				print "game level is loaded"
				return true
			}catch(e){
				print "exception: ${e.message}"
				printBackTrace(e.trace)
				return notLoaded(e.message)
			}
		}
		if(!loaded){
			@registerLevelData(@tiledmapWidth, @tiledmapHeight, data)
			for(var _, obj in level.groups.entities.objects){
				@addTiledmapEntity(obj) // .x, obj.y, obj.gid, obj.type)
			}
			print "game level is initialized"
		}
	},
	
	saveGame = function(saveSlotNum){
		saveSlotNum || return;
		@closeModal()
		
		var saveSlot = GAME_SETTINGS.saveSlots[@saveSlotNum = saveSlotNum]
		var levelNum = saveSlot.levelNum || 1
		var xor = (saveSlot.xor || 0) ^ 1
		var saveJsonFilename = "save-${@saveSlotNum}-${levelNum}-${xor}.json"
		
		GAME_SETTINGS.saveSlots[@saveSlotNum] = {
			levelNum = levelNum,
			xor = xor,
			date = DateTime.now(),
		}
		
		var levelSave = {
			jsonCRC = @levelJsonCRC,
			dataCRC = @levelDataCRC,
			width = @tiledmapWidth,
			height = @tiledmapHeight,
			floor = @tiledmapFloor,
			state = @getGameState(),
			entities = [],
		}
		
		for(var _, ent in @tileEnt){
			var obj = {
				type = ent.typeName,
				gid = ent.type,
				// x = ent.tileX,
				// y = ent.tileY,
				state = ent.getState(),
			}
			levelSave.entities[] = obj
		}
		File.writeContents(saveJsonFilename, json.encode(levelSave))
		
		var data = zlib.gzcompress(@retrieveLevelData())
		File.writeContents(saveJsonFilename.replace(".json", ".bin"), data)
		
		saveGameSettings()
	},
	
	reloadGame = function(){
		@loadGame(@saveSlotNum)
	},
	
	loadGame = function(saveSlotNum){
		// @saveSlotNum || throw
		@touchEnabled = false
		@touchChildrenEnabled = false
		var rect = ColorRectSprite().attrs {
			size = @size,
			color = Color.BLACK,
			priority = GAME_PRIORITY_FADEIN,
			opacity = 0,
			parent = this,
		}
		TextField().attrs {
			resFont = res.get("test_2"),
			vAlign = TEXT_VALIGN_BOTTOM,
			hAlign = TEXT_HALIGN_LEFT,
			text = _T("Loading..."),
			pos = @size * vec2(0.08, 0.8),
			color = Color.WHITE * 0.8,
			parent = rect,
		}
		rect.addTweenAction {
			duration = 1.0,
			opacity = 1,
			// detachTarget = true,
			doneCallback = function(){
				@addTimeout(0.7, function(){
					@cleanupActor(this)
					Game4X(saveSlotNum)
				})
			},
		}
	},
	
	cleanup = function(){
		print "begin game cleanup, max alloc: ${gc.allocatedBytes}, used: ${gc.usedBytes}"
		@keyEventDownId && stage.removeEventListener(@keyEventDownId)
		@keyEventUpId && stage.removeEventListener(@keyEventUpId)
		@removeChildren()
		@detach()
		@clear()
		gc.full()
		print "end game cleanup, max alloc: ${gc.allocatedBytes}, used: ${gc.usedBytes}"
	},
	
	getGameState = function(){
		var state = {
			// maxStamina = @playerMaxStamina,
			player = Player.getPlayerState(),
			hudSlots = {},
		}
		for(var hudSlotNum, slot in @hudSlots){
			state.hudSlots[hudSlotNum] = slot.type
		}
		return state
	},
	
	loadGameState = function(state){
		// @playerMaxStamina = math.max(@playerMaxStamina, toNumber(state.maxStamina))
		Player.loadPlayerState(state.player)
		for(var hudSlotNum, type in state.hudSlots){
			if(hudSlotNum >= 0 && hudSlotNum < #@hudSlots){
				@hudSlots[hudSlotNum].type = type
			}
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
	
	explodeTileItem = function(tx, ty, radius, wait){
		@getTile(tx, ty).explodeItem()
	},
	
	playBlockSound = function(){
		if(!@blockSound && @time - @blockSoundTime > 0.5){
			var name = sprintf("block-%02d", math.round(math.random(1, 3)))
			@blockSound = splayer.play {
				sound = name,
			}
			@blockSound.doneCallback = function(){
				@blockSound = null
			}
			@blockSoundTime = @time
		}
	},
	
	playRockBreakSound = function(){
		if(!@rockBreakSound && @time - @rockBreakSoundTime > 5.0){
			var name = sprintf("rock-break-%02d", math.round(math.random(1, 4)))
			@rockBreakSound = splayer.play {
				sound = name,
			}
			@rockBreakSound.doneCallback = function(){
				@rockBreakSound = null
			}
			@rockBreakSoundTime = @time
		}
	},
	
	playRockfallSound = function(){
		var name = sprintf("rock-break-%02d", math.round(math.random(5, 6)))
		splayer.play {
			sound = name,
		}
	},
	
	playDigSound = function(){
		if(!@digSound){ // && @time - @digSoundTime > 0.5){
			var name = sprintf("dig-%02d", math.round(math.random(1, 2)))
			@digSound = splayer.play {
				sound = name,
			}
			@digSound.doneCallback = function(){
				@digSound = null
			}
			@digSoundTime = @time
		}
	},
	
	bubbleItem = function(ent, tx, ty, itemType){
		// print "bubbleItem"
		if("speechBubble" in ent == false && @saveSlotNum){
			var getBubblePos = function(){
				return ent.pos + vec2(TILE_SIZE * 0.0, -TILE_SIZE * 0.5)
			}
			ent.speechBubble = SpeechBubble(this, itemType, function(){
				ent.speechBubble.detach()
				delete ent.speechBubble
			}).attrs {
				// pos = vec2(TILE_SIZE * 0.5, -TILE_SIZE * 0.2),
				// parent = ent,
				pos = getBubblePos(), // + vec2(TILE_SIZE * 0.7, -TILE_SIZE * 0.2),
				parent = @speechBubbles,
			}
			ent.speechBubble.addUpdate(function(){
				ent.speechBubble.pos = getBubblePos()
			})
			// print "bubble created"
		}
	},
	
	checkBombBubble = function(ent, tx, ty){
		if(@time - @checkBombBubbleTime > 1){
			@checkBombBubbleTime = @time
			if(math.random() < 0.1){
				@bubbleItem(ent, tx, ty, randItem(BOMB_ITEMS_INFO.keys))
			}
		}
	},
	
	removeCrack = function(tx, ty, cleanup){
		var key = "${tx}-${ty}"
		var crack = @tileCracks[key]
		if(crack){
			delete @tileCracks[key]
			crack.detach()
			cleanup && @cleanupActor(crack) // .cleanup()
		}
	},
	
	pickTile = function(tx, ty, byTouch){
		if(math.abs(@player.tileX - tx) > 1 || math.abs(@player.tileY - ty) > 1){
			// playErrClickSound()
			return
		}
		var tile = @getTile(tx, ty)
		var type = @getAutoFrontType(tx, ty)
		var tileInfo = TILES_INFO[type]
		if(!tileInfo.strength){
			var soundPlayed = false
			if(!tile.pickByEnt(@player)){
				if(Player.pickItemType && type != TILE_TYPE_EMPTY){
					@playBlockSound()
					@checkBombBubble(@player, tx, ty)
					soundPlayed = true
				}
			}
			// soundPlayed || playErrClickSound()
			return
		}
		if(!Player.pickItemType){
			@bubbleItem(@player, tx, ty, ITEM_TYPE_SHOVEL)
			playErrClickSound()
			return
		}
		var itemInfo = ITEMS_INFO[tile.itemType]
		var damage = ITEMS_INFO[Player.pickItemType].pickDamage || 1
		var deepStrength = math.abs(ty - @tiledmapFloor) / 15
		var strength = math.round(((tileInfo.strength || 3) + deepStrength) 
				* (itemInfo.strengthScale || 1) / damage)
		if(strength > 15){
			print "tile ${tx}x${ty} too strength: ${strength}, deep: ${math.round(deepStrength, 2)}, damage: ${damage}"
			tile.pickByEnt(@player) || @playBlockSound()
			
			for(var pickType, pickItem in PICK_DAMAGE_ITEMS_INFO){
				var damage = pickItem.pickDamage || 1
				var strength = math.round(((tileInfo.strength || 3) + deepStrength) 
						* (itemInfo.strengthScale || 1) / damage)
				strength <= 15 && break
			}
			if(pickType && math.random() < 0.95){
				@bubbleItem(@player, tx, ty, pickType)
			}else{
				@bubbleItem(@player, tx, ty, randItem(BOMB_ITEMS_INFO.keys))
			}
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
				crack.detach()
				delete @tileCracks[key]
				@cleanupActor(crack)
				
				@setFrontType(tx, ty, TILE_TYPE_EMPTY)
				if(tile.itemType != ITEM_TYPE_EMPTY){
					if(@takeTileItem(tile.itemType, tx, ty)){
						@player.playTakeItemSound()
					}
				}
				@removeTile(tx, ty, true)
				@updateTile(tx, ty)
				@updateTiledmapShadowViewport(tx-1, ty-1, tx+1, ty+1, true)
				@playRockBreakSound()
				return true
			}
			crack.nextDamageTime = @time + crack.damageDelay
			@player.useStaminaByCrack()
			@playDigSound()
		}
		crack.resAnimFrameNum = (crack.damage+1) * crack.resAnim.totalFrames / crack.strength
		return true
	},
	
	takeTileItem = function(type, tx, ty){
		if(Backpack.addItem(type)){
			@setItemType(tx, ty, ITEM_TYPE_EMPTY)
			@backpackIcon.scale = 1
			var action = EaseAction(TweenAction {
				duration = 0.5,
				scale = 1.2,
				ease = Ease.PING_PONG
			}, Ease.CUBIC_IN_OUT)
			@backpackIcon.replaceAction("note", action)
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
		if(group == "tile-item"){
			ITEMS_INFO[type].hasTileSprite || return;
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
	
	updateTiledmapShadowViewport = function(ax, ay, bx, by, recreate){
		for(var y = ay; y <= by; y++){
			for(var x = ax; x <= bx; x++){
				var tile = @getTile(x, y)
				tile.updateShadow(recreate)
			}
		}
	},
	
	updateTiledmapViewport = function(ax, ay, bx, by, recreate){
		for(var y = ay; y <= by; y++){
			for(var x = ax; x <= bx; x++){
				@updateTile(x, y)
			}
		}
		@updateTiledmapShadowViewport(ax, ay, bx, by, recreate)
	},
	
	playerDead = function(){
		@reloadGame()
		return
	
		Player.pickItemType = null
		// Player.laddersItemType = null
		Backpack.pack.items = {}
		Backpack.pack.updateNumItems()
		@updateHudItems()
		
		// @player.reset()
		// @unsetEntTile(@player)
		// @initEntTile(@player, Player.saveTileX, Player.saveTileY)
		
		@player = Player(this, Player.saveType)
		@initEntTile(@player, Player.saveTileX, Player.saveTileY)
		@centerViewToTile(Player.saveTileX, Player.saveTileY)
		
		@addTimeout(3, function(){
			if(!Player.pickItemType){
				@bubbleItem(@player, @player.tileX, @player.tileY, ITEM_TYPE_SHOVEL)
			}
		})
	},
	
	addTiledmapEntity = function(obj, state){ // x, y, type, isPlayer){
		var entInfo = ENTITIES_INFO[obj.gid]
		if(entInfo.class === "Player"){
			@player && throw "player is already exist"
			@player = Player(this, obj.gid)
			if(state){
				@player.loadState(state)
			}else{
				@initEntTile(@player, obj.x, obj.y)
			}
			Player.saveType = obj.gid
			Player.saveTileX = @player.tileX
			Player.saveTileY = @player.tileY
			@centerViewToTile(@player.tileX, @player.tileY)
			@addTimeout(3, function(){
				if(!Player.pickItemType){
					@bubbleItem(@player, @player.tileX, @player.tileY, ITEM_TYPE_SHOVEL)
				}
			})
			return @player
		}
		if(obj.gid > 0){
			var ent = _G[entInfo.class || "Monster"](this, obj.gid)
			if(state){
				ent.loadState(state)
			}else{
				@initEntTile(ent, obj.x, obj.y)
				ent.createPatrolAreaIfNecessary()
			}
			return ent
		}
		throw "unknown entity tiledmap type: ${obj.gid}"
	},
	
	removeTile = function(tx, ty, cleanup){
		var key = "${tx}-${ty}"
		var tile = @tiles[key]
		if(tile){
			delete @tiles[key]
			tile.detach()
			cleanup && @cleanupActor(tile) // .cleanup()
		}
	},
	
	markTileVisibility = function(tile, visible){
		if(!visible){
			// print "DELETE tile ${tile.tileX}x${tile.tileY}, type: ${tile.tileType}, name: ${tile.resAnim.name}"
			// delete @tiles["${tile.tileX}-${tile.tileY}"]
			// tile.detach()
			// tile.cleanup()
			@removeTile(tile.tileX, tile.tileY, true)
		}
	},
	
	markEntVisibility = function(ent, visible){
		
	},
	
	centerViewToTile = function(tx, ty){
		var pos = @tileToCenterPos(tx, ty) - @centerViewPos / @view.scale
		@viewPos = -pos * @view.scale
		// @view.pos = -pos * @view.scale
		// @glowingTiles.pos = @view.pos
		// @updateView()
	},
	
	__get@viewPos = function(){
		return @view.pos
	},
	__set@viewPos = function(value){
		@view.pos = value
		@glowingTiles.pos = value
		@speechBubbles.pos = value
	},
	
	/* followPlayer = function(){
		var viewScale = @view.scale
		var idealPos = (@size / 2 / viewScale - @player.pos) * viewScale
		var pos = @view.pos
		pos = pos + (idealPos - pos) * math.min(1, 3.0 * @dt)
		
		var maxOffs = @size * 0.3 / viewScale
		if(idealPos.x - pos.x > maxOffs.x){
			pos.x = idealPos.x - maxOffs.x
		}else if(idealPos.x - pos.x < -maxOffs.x){
			pos.x = idealPos.x + maxOffs.x
		}
		if(idealPos.y - pos.y > maxOffs.y){
			pos.y = idealPos.y - maxOffs.y
		}else if(idealPos.y - pos.y < -maxOffs.y){
			pos.y = idealPos.y + maxOffs.y
		}
		
		// pos.x = math.round(pos.x) // * @view.scaleX)
		// pos.y = math.round(pos.y) // * @view.scaleY)
		
		@view.pos = pos
		@glowingTiles.pos = pos
		
		@updateView()
	}, */
	
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
	
	updateViewport = function(startX, startY, endX, endY){
		@updateTiledmapViewport(startX, startY, endX, endY)
		for(var _, tile in @layers[LAYER_TILES]){
			@markTileVisibility(tile, tile.time == @time)
		}
	},
	
	updateView = function(){
		var offs = -@view.pos / @view.scale
		var startX, startY = @posToTile(offs)
		var edge = 0
		startX, startY = startX - edge-1, startY - edge
		if(startX != @oldViewTilePosX || startY != @oldViewTilePosY){
			@oldViewTilePosX, @oldViewTilePosY = startX, startY
			
			var endOffs = offs + @size / @view.scale
			var endX, endY = @posToCeilTile(endOffs)
			endX, endY = endX + edge+1, endY + edge
			
			@updateTiledmapViewport(startX, startY, endX, endY)
			
			/* for(var i = @numLights-1; i >= 0; i--){
				var light = @getLight(i)
				var startLightX, startLightY = @posToTile(light.pos - light.radius)
				var endLightX, endLightY = @posToCeilTile(light.pos + light.radius)
				if(startLightX <= endX && endLightX >= startX
					&& startLightY <= endY && endLightY >= startY)
				{
					@updateTiledmapViewport(startLightX, startLightY, endLightX, endLightY)
				}
			} */
			
			for(var _, tile in @layers[LAYER_TILES]){
				@markTileVisibility(tile, tile.time == @time)
			}
			// print "alive tiles: ${#@layers[LAYER_TILES]}"
		}
	},
	
	shakeCamera = function(size, time){
		time || time = 2
		size = size * TILE_SIZE
		@view.removeUpdate(@shakeUpdateHandle)
		var accumTime = 0
		@shakeUpdateHandle = @view.addUpdate(function(ev){
			accumTime += ev.dt
			if(accumTime > time){
				@view.removeUpdate(@shakeUpdateHandle)
				@shakeUpdateHandle = null
				return
			}
			var t = Ease.run(1 - accumTime / time, Ease.CUBIC_OUT)
			// var t = 1 - accumTime / time
			var shakeOffs = vec2(randSign() * size * t, randSign() * size * t)
			@viewPos += shakeOffs
		})
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
		for(var _, sprite in @glowingTiles){
			if("glowPhase" in sprite == false){
				sprite.glowPhase = math.random() * 100
				sprite.glowTimeScale = math.random(0.7, 1.5)
			}
			var t = (math.sin(sprite.glowPhase + @time * 2 * sprite.glowTimeScale) + 1) / 2
			sprite.opacity = 0.3 + 0.7 * t
		}
		/* for(var i = @numLights-1; i >= 0; i--){
			var light = @getLight(i)
			if("updateCallback" in light){
				var updateCallback = light.updateCallback
				updateCallback()
			}
		} */
		
		// @followPlayer()
		// @updateLightLayer(@lightLayer)
		@updateCamera(@lightLayer)
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