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

PLAYER_FOOT_SOUNDS = {
	block = [
		"foot-01-01", "foot-01-02", "foot-01-03", "foot-01-04", "foot-01-05", "foot-01-06",
	],
	
	chernozem = [
		"foot-02-01", "foot-02-02", "foot-02-03", "foot-02-04", "foot-02-05", "foot-02-06", "foot-02-07",
	],
}

PLAYER_PAIN_SOUNDS = [
	"player-pain-01", "player-pain-02", "player-pain-03", "player-pain-04", "player-pain-05", 
	"player-pain-06", "player-pain-07", "player-pain-08",
]

PLAYER_DEATH_SOUNDS = [
	"player-death-01", "player-death-02",
]

PLAYER_ITEM_SOUNDS = [
	"item-01", "item-02", "item-03",
]

Player = extends Entity {
	bullets = 0,
	
	pickItemType = null,
	pickItemUsage = {},
	
	// laddersItemType = null,
	
	saveTileX = null,
	saveTileY = null,
	saveName = null,
	
	getPlayerState = function(){
		return {
			bullets = Player.bullets,
			pickItemType = Player.pickItemType,
			pickItemUsage = Player.pickItemUsage,
			backpack = Backpack.getState(),
		}
	},
	
	loadPlayerState = function(state){
		// Player.bullets = math.max(Player.bullets, toNumber(state.player.bullets))
		Player.bullets = math.max(0, toNumber(state.bullets))
		Player.pickItemType = numberOf(state.pickItemType)
		if(Player.pickItemType in PICK_DAMAGE_ITEMS_INFO == false){
			Player.pickItemType = null
		}
		Player.pickItemUsage = arrayOf(state.pickItemUsage) || {}
		Backpack.loadState(state.backpack)
	},

	getState = function(){
		return super().merge {
			health = @healthValue,
			damage = @damageValue,
		}
	},
	
	loadState = function(state){
		super(state)
		@healthValue = math.max(PLAYER_START_HEALTH, toNumber(state.health))
		@healthValue = math.min(PLAYER_MAX_HEALTH, @healthValue)
		@damageValue = math.max(0, toNumber(state.damage))
		@updateHealthBar()
	},
	__construct = function(game, name){
		super(game, name)
		@parent = game.layers[LAYER_PLAYER]
		@isPlayer = true
		// @_stamina = 0; @stamina = game.playerMaxStamina // update stamina bar
		@healthValue = PLAYER_START_HEALTH
		@updateHealthBar()
		
		@staminaUpdateHandle = null
		@startBreathing()
		// @jumpTileX = @jumpTileY = null
		@footSound = null
		@painSound = null
		@itemSound = null
		@jumpSound = null
		
		@lightTileRadius = 2.5
		@lightTileRadiusScale = 1.5 // dependence on light name
		@light = Light().attrs {
			name = "light-01",
			shadowColor = Color(0.1, 0.1, 0.1),
			radius = 0, // @lightTileRadius * @lightTileRadiusScale * TILE_SIZE,
			color = Color(0.8, 1.0, 1.0),
			// tileRadius = @lightTileRadius,
			// parent = this,
		}
		@game.addLight(@light)
		
		@addUpdate(0.3, @updatePlayerSector.bind(this))
		@addTimeout(0.001, @onTileChanged.bind(this))
	},
	
	cleanup = function(){
		@game.removeLight(@light)
	},
	
	reset = function(){
		@isPlayer = true
		@isDead = false
		// @_stamina = @game.playerMaxStamina
		@damageValue = 0
		@updateHealthBar()
		// @game.hudStamina.value = 1
		@sprite.attrs {
			pos = @idealPos,
			scale = @idealScale,
			angle = 0,
			opacity = 1,
			color = Color.WHITE,
		}
	},
	
	playFootSound = function(type){
		if(!@footSound){
			var name = randItem(PLAYER_FOOT_SOUNDS[type])
			@footSound = splayer.play {
				sound = name,
			}
			@footSound.doneCallback = function(){
				@footSound = null
			}
		}
	},
	
	playPainSound = function(){
		if(!@painSound){
			var name = randItem(PLAYER_PAIN_SOUNDS)
			@painSound = splayer.play {
				sound = name,
			}
			@painSound.doneCallback = function(){
				@painSound = null
			}
		}
	},
	
	playUseItemSound = function(sounds){
		if(sounds){
			@playTakeItemSound(sounds)
		}else{
			playMenuClickSound()
		}
	},
	
	playTakeItemSound = function(sounds){
		if(!@itemSound){
			var name = randItem(sounds || PLAYER_ITEM_SOUNDS)
			@itemSound = splayer.play {
				sound = name,
			}
			@itemSound.doneCallback = function(){
				@itemSound = null
			}
		}
	},
	
	playJumpSound = function(){
		if(!@jumpSound){
			@jumpSound = splayer.play {
				sound = "jump",
			}
			@jumpSound.doneCallback = function(){
				@jumpSound = null
			}
		}
	},
	
	playDeathSound = function(){
		splayer.play {
			sound = randItem(PLAYER_DEATH_SOUNDS),
		}
	},
	
	updateHealthBar = function(){
		if(@damageValue < 0){
			@damageValue = 0
		}else if(@damageValue >= @healthValue){
			@damageValue = @healthValue
			@die()
		}
		var t = 1 - @damageValue / @healthValue
		if(t > 0.75){
			@startBreathing(1.0)
		}else if(t > 0.5){
			@startBreathing(2.0)
		}else if(t > 0.25){
			@startBreathing(4.0)
		}else{
			@startBreathing(8.0)
		/* }else if(t > 0){
			@startBreathing(8.0)
		}else{
			@die() */
		}
		@game.hudStamina.width = @healthValue * 1.0
		@game.hudStamina.visible = true
		@game.hudStamina.value = t
	},
	
	/* __get@stamina = function(){
		return @_stamina
	},
	
	__set@stamina = function(value){
		var maxStamina = @game.playerMaxStamina
		@_stamina = value < 0 ? 0 
			: value > maxStamina ? maxStamina
			: value
		var t = @_stamina / maxStamina
		if(t > 0.75){
			@startBreathing(1.0)
		}else if(t > 0.5){
			@startBreathing(2.0)
		}else if(t > 0.25){
			@startBreathing(4.0)
		}else if(t > 0){
			@startBreathing(8.0)
		}else{
			@die()
		}
		@game.hudStamina.value = t
		// @game.hudStaminaNumber.text = math.round(@_stamina, 1)
	}, */
	
	useStamina = function(value){
		value || value = 1
		// @stamina -= value
		@damageValue += value
		@updateHealthBar()
		
	},
	
	damage = function(value, attacker){
		print "player damaged: ${value}"
		if(value > @healthValue * 0.1){
			@game.createBlood(value)
		}
		@playPainSound()
		@useStamina(value)
	},
	
	useStaminaByCrack = function(){
		@useStamina(1)
	},
	
	updatePlayerSector = function(){
		for(var _, tile in @game.tiles){
			var ent = @getTileEnt(tile.tileX, tile.tileY)
			ent.queryAI()
		}
		/* for(var x = -2; x <= 2; x++){
			for(var y = -2; y <= 2; y++){
				// x == 0 && y == 0 && continue
				var ent = @getTileEnt(@tileX + x, @tileY + y)
				if(ent is Monster){
					ent.queryAI()
				}
			}
		} */
	},
	
	updateMoveDir = function(){
		super()
	},
	
	canUseLaddersAt = function(tx, ty){
		@moving && return;
		var useDistance = ITEMS_INFO[ITEM_TYPE_LADDERS].useDistance || 1
		if(/*Player.laddersItemType &&*/ !@isDead
			&& @game.getBackType(tx, ty) != TILE_TYPE_TRADE_STOCK
			&& math.abs(tx - @tileX) <= useDistance && math.abs(ty - @tileY) <= useDistance)
		{
			var curTileType = @game.getFrontType(tx, ty)
			var upTileType = @game.getFrontType(tx, ty - 1)
			var downTileType = @game.getFrontType(tx, ty + 1)
			var leftTileType = @game.getFrontType(tx - 1, ty)
			var rightTileType = @game.getFrontType(tx + 1, ty)
			if(curTileType == TILE_TYPE_EMPTY
				&& (upTileType != TILE_TYPE_EMPTY
					|| downTileType != TILE_TYPE_EMPTY
					|| leftTileType != TILE_TYPE_EMPTY
					|| rightTileType != TILE_TYPE_EMPTY
					)
				&& leftTileType != TILE_TYPE_LADDERS
				&& rightTileType != TILE_TYPE_LADDERS
				/* && (upTileType != TILE_TYPE_EMPTY
					|| downTileType != TILE_TYPE_EMPTY
					|| (leftTileType != TILE_TYPE_LADDERS && leftTileType != TILE_TYPE_EMPTY)
					|| (rightTileType != TILE_TYPE_LADDERS && rightTileType != TILE_TYPE_EMPTY)
					) */
				// && (upTileType != TILE_TYPE_LADDERS && upTileType != TILE_TYPE_EMPTY)
				// 	!= (downTileType != TILE_TYPE_LADDERS && downTileType != TILE_TYPE_EMPTY)
				)
			{
				if(tx == @tileX && ty == @tileY-1){
					var playerTileType = @game.getFrontType(@tileX, @tileY)
					if(playerTileType == TILE_TYPE_EMPTY){
						return Backpack.pack.hasItems(ITEM_TYPE_LADDERS, 2)
					}
				}
				return true
			}
		}
	},
	
	canUseItemAt = function(type, tx, ty){
		@game.modalView.visible && return;
		type == ITEM_TYPE_LADDERS && return @canUseLaddersAt(tx, ty)
		var useDistance = ITEMS_INFO[type].useDistance || 1
		if(!@isDead
			// && @game.getBackType(tx, ty) != TILE_TYPE_TRADE_STOCK
			&& math.abs(tx - @tileX) <= useDistance && math.abs(ty - @tileY) <= useDistance
			// && @game.getTile(tx, ty).isEmpty
			)
		{
			var type = @game.getFrontType(tx, ty)
			if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS){
				return @game.getItemType(tx, ty) == ITEM_TYPE_EMPTY
					|| ITEMS_INFO[type].stamina
					|| ITEMS_INFO[type].addMaxStamina
			}
		}
	},
	
	useLaddersAt = function(tx, ty){
		if(@canUseLaddersAt(tx, ty)){
			if(tx == @tileX && ty == @tileY-1){
				var playerTileType = @game.getFrontType(@tileX, @tileY)
				if(playerTileType == TILE_TYPE_EMPTY){
					if(!@useLaddersAt(@tileX, @tileY)){
						return
					}
				}
			}
			if(Backpack.pack.subItem(ITEM_TYPE_LADDERS)){
				@playUseItemSound(ITEMS_INFO[ITEM_TYPE_LADDERS].useSounds)
				@game.updateHudItems()
				@game.setFrontType(tx, ty, TILE_TYPE_LADDERS)
				@game.removeTile(tx, ty, true)
				@game.updateTile(tx, ty)
				@game.updateTiledmapShadowViewport(tx-1, ty-1, tx+1, ty+1, true)
				return true
			}
		}
	},
	
	useItem = function(type){
		return @useItemAt(type, @tileX, @tileY)
	},
	
	useItemAt = function(type, tx, ty){
		type == ITEM_TYPE_LADDERS && return @useLaddersAt(tx, ty)
		if(@canUseItemAt(type, tx, ty) && Backpack.pack.subItem(type)){
			@playUseItemSound(ITEMS_INFO[type].useSounds)
			@game.updateHudItems()
			if(ITEMS_INFO[type].addMaxStamina){
				@healthValue = @healthValue + ITEMS_INFO[type].addMaxStamina
				@healthValue = math.max(PLAYER_START_HEALTH, @healthValue)
				@healthValue = math.min(PLAYER_MAX_HEALTH, @healthValue)
				@damageValue = 0
				@updateHealthBar()
				return true
			}
			if(ITEMS_INFO[type].stamina){
				@useStamina(-ITEMS_INFO[type].stamina)
				return true
			}
			@game.setItemType(tx, ty, type)
			@game.removeTile(tx, ty, true)
			@game.updateTile(tx, ty)
			@game.updateTiledmapShadowViewport(tx-1, ty-1, tx+1, ty+1, true)
			if(ITEMS_INFO[type].explodeRadius){
				@game.explodeTileItem(tx, ty)
			}
			return true
		}
	},
	
	blockFalling = function(afterJump){
		/* if(afterJump){
			@jumpTileX, @jumpTileY = @tileX, @tileY
			return // @useLaddersAt(@tileX, @tileY)
		}
		if(@jumpTileX !== @tileX && @jumpTileY !== @tileY && @isTileEmptyToFall(@tileX, @tileY + 2)){
			return // @useLaddersAt(@tileX, @tileY)
		} */
	},
	
	onTileChanged = function(){
		/* if(@prevTileY > @tileY){
			@useStamina(0.5)
		}else if(@prevTileY < @tileY){
			@useStamina(0.5)
		}else{
			@useStamina(0.5)
		} */
		// @jumpTileX = @jumpTileY = null
		var tx, ty = @tileX, @tileY
		var type = @game.getBackType(tx, ty)
		if(type != TILE_TYPE_TRADE_STOCK){
			@useStamina(0.5)
			if(@staminaUpdateHandle){
				@game.removeUpdate(@staminaUpdateHandle)
				@staminaUpdateHandle = null
				@game.disableSaveLoad()
			}
		}else if(!@staminaUpdateHandle){
			@game.enableSaveLoad()
			@staminaUpdateHandle = @game.addUpdate(function(ev){
				@useStamina(-(@healthValue / 10) * ev.dt)
				// @stamina += (@game.playerMaxStamina / 10) * ev.dt
			})
		}
		var tile = @game.getTile(tx, ty - 1)
		tile.checkStartFalling()
		
		var type = @game.getFrontType(tx, ty)
		if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS){
			var type = @game.getItemType(tx, ty)
			if(type != ITEM_TYPE_EMPTY && type != ITEM_TYPE_STAND_FLAME_01){
				if(@game.takeTileItem(type, tx, ty)){
					@game.removeTile(tx, ty, true)
					// @game.removeCrack(tx, ty, true)
					@game.updateTile(tx, ty)
					@game.updateTiledmapShadowViewport(tx-1, ty-1, tx+1, ty+1, true)
					@playTakeItemSound()
				}
			}
		}
		var type = @game.getFrontType(tx, ty + 1)
		if(type == TILE_TYPE_ROCK || type == TILE_TYPE_BLOCK){
			@playFootSound('block')
		}else if(type != TILE_TYPE_EMPTY){
			@playFootSound('chernozem')
		}
	},
	
	update = function(){
		if(@game.moveJoystick.active && !@isDead){
			@moveDir = @game.moveJoystick.dir
			@updateMoveDir()
		}else{
			// @moveDir = vec2(0, 0)
		}
		super()
		
		@light.pos = @pos + vec2(math.random(-0.02, 0.02) * TILE_SIZE, math.random(-0.02, 0.02) * TILE_SIZE)
		@light.radius = @lightTileRadius * @lightTileRadiusScale * TILE_SIZE * math.random(0.97, 1.03)
	},
}