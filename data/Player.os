Player = extends Entity {
	__construct = function(game, name){
		super(game, name)
		@parent = game.layers[LAYER_PLAYER]
		@isPlayer = true
		@_stamina = game.playerMaxStamina
		@staminaUpdateHandle = null
		@startBreathing()
		@addUpdate(0.3, @updatePlayerSector.bind(this))
	},
	
	__get@stamina = function(){
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
		}else{
			@startBreathing(8.0)
		}
		@game.hudStamina.value = t
		// @game.hudStaminaNumber.text = math.round(@_stamina, 1)
	},
	
	useStamina = function(value){
		@stamina -= value || 1
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
	
	onTileChanged = function(){
		/* if(@prevTileY > @tileY){
			@useStamina(0.5)
		}else if(@prevTileY < @tileY){
			@useStamina(0.5)
		}else{
			@useStamina(0.5)
		} */
		var tx, ty = @tileX, @tileY
		var type = @game.getBackType(tx, ty)
		if(type != TILE_TYPE_TRADE_STOCK){
			@useStamina(0.5)
			if(@staminaUpdateHandle){
				@game.removeUpdate(@staminaUpdateHandle)
				@staminaUpdateHandle = null
			}
		}else if(!@staminaUpdateHandle){
			@staminaUpdateHandle = @game.addUpdate(function(ev){
				@stamina += (@game.playerMaxStamina / 10) * ev.dt
			}.bind(this))
		}
		var type = @game.getFrontType(tx, ty - 1)
		if(type == TILE_TYPE_ROCK){
			var tile = @game.getTile(tx, ty)
			if(!(tile is Door)){
				type = @game.getFrontType(tx, ty + 1)
				if(type != TILE_TYPE_EMPTY){
					var tile = @game.getTile(tx, ty - 1)
					tile.startFalling()
				}
			}
		}
		// @game.followPlayer()
	},
	
	update = function(){
		if(@game.moveJoystick.active){
			@moveDir = @game.moveJoystick.dir
			@updateMoveDir()
		}else{
			// @moveDir = vec2(0, 0)
		}
		super()
	},
}