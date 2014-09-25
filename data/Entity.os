Entity = extends Actor {
	__object = {
		tileX = -1,
		tileY = -1,
		prevTileX = -1,
		prevTileY = -1,
		
		breathingSpeed = 1.0,
		attackSpeed = 1.0,
		moveSpeed = 1.0,
		
		centerActionHandle = null,
		attackCallback = null,
		// moveTween = null,
		
		isPlayer = false,
		falling = false,
		moving = false,
		jumping = false,
		
		repeatMove = 0,
	},
	
	__construct = function(game, name){
		super()
		@game = game
		@name = name
		@sprite = Sprite().attrs {
			resAnim = res.get(name),
			pivot = vec2(0.5, 0.5),
			scale = 0.9,
			parent = this,
		}
		@pivot = vec2(0.5, 0.5)
		@size = @sprite.size 
		@sprite.pos = @idealPos = @size/2
		@touchChildrenEnabled = false
		@breathing()
	},
	
	centerSprite = function(){
		@sprite.replaceTweenAction {
			name = "centerSprite",
			duration = 0.1,
			pos = @idealPos,
			angle = 0,
		}
	},
	
	setTile = function(tx, ty){
		if(@tileX != tx){
			@replaceTweenAction {
				name = "scaleX",
				duration = 0.15 * @moveSpeed,
				scaleX = @tileX > tx ? 1 : -1,
				ease = Ease.CUBIC_IN_OUT,
			}
		}
		@game.setEntTile(this, tx, ty)
	},
	
	setTilePos = function(tx, ty){
		@setTile(tx, ty)
		@pos = @game.tileToCenterPos(tx, ty)
	},
	
	getTileType = function(tx, ty){
		return @game.getTileType(tx, ty)
	},
	
	getTileEnt = function(tx, ty){
		return @game.getTileEnt(tx, ty)
	},
	
	isTileEmptyToMove = function(tx, ty){
		var type = @getTileType(tx, ty)
		return (type == TILE_EMPTY || type == TILE_STAIRS) 
			&& !@getTileEnt(tx, ty)
	},
	
	isTileEmptyToFall = function(tx, ty){
		var type = @getTileType(tx, ty)
		return type == TILE_EMPTY
			&& !@getTileEnt(tx, ty)
	},
	
	moveToSide = function(dx, dy, ease){
		assert(dx == 1 || dx == -1 || dx == 0)
		assert(dy == 1 || dy == -1 || dy == 0)
		if(dx != 0){
			var tx, ty = @tileX + dx, @tileY
			if(@moving){
				if(tx != @prevTileX){
					@repeatMove++
					return
				}else{
					@repeatMove = 0
				}
			}
			if(@isTileEmptyToMove(tx, ty)
				// && (dy <= 0 || @getTileType(@tileX, @tileY+1) != TILE_STAIRS)
				)
			{
				var time = 0.3 * @moveSpeed
				@setTile(tx, ty)
				@moving = @replaceTweenAction {
					name = "moving",
					duration = time,
					x = @game.tileToCenterPos(tx, ty).x,
					ease = ease || Ease.LINEAR,
					doneCallback = function(){
						@moving = false
						if(@repeatMove > 0){
							@repeatMove--
							@moveToSide(dx, dy, Ease.LINEAR)
						}
					}.bind(this),
				}
				return
			}
			ty--
			if(!@falling && !@jumping && !@moving && @isTileEmptyToMove(tx, ty) 
				&& @isTileEmptyToMove(@tileX, ty)
				&& (dy <= 0 || @getTileType(@tileX, @tileY+1) != TILE_STAIRS))
			{
				/* if(@falling){
					if(tx != @prevTileX){
						@repeatMove++
					}else{
						@repeatMove = 0
					}
					return
				} */
				var time = 0.3 * @moveSpeed
				@setTile(tx, ty)
				var pos = @game.tileToCenterPos(tx, ty)
				@moving = @replaceTweenAction {
					name = "moving",
					duration = time * 1.7,
					x = pos.x,
					ease = ease || Ease.LINEAR,
					doneCallback = function(){
						@moving = false
						if(@repeatMove > 0){
							@repeatMove--
							@moveToSide(dx, dy, Ease.LINEAR)
						}
					}.bind(this),
				}
				@jumping = @replaceTweenAction {
					name = "jumping",
					duration = time * 1.5,
					y = pos.y,
					ease = Ease.BACK_IN_OUT,
					doneCallback = function(){
						@jumping = false
						// callback()
					}.bind(this),
				}
				return
			}
		}
		if(dy != 0){
			var tx, ty = @tileX, @tileY + dy
			if(@moving){
				if(ty != @prevTileY){
					@repeatMove++
					return
				}else{
					@repeatMove = 0
				}
			}
			if(@isTileEmptyToMove(tx, ty)){
				var time = 0.3 * @moveSpeed
				@setTile(tx, ty)
				@moving = @replaceTweenAction {
					name = "moving",
					duration = time,
					y = @game.tileToCenterPos(tx, ty).y,
					ease = ease || Ease.LINEAR,
					doneCallback = function(){
						@moving = false
						if(@repeatMove > 0){
							@repeatMove--
							@moveToSide(dx, dy, Ease.LINEAR)
						}
					}.bind(this),
				}
				return
			}
		}
	},
	
	startFalling = function(){
		DEBUG && assert(@canFalling())
		@falling = true
		var time, fallTiles = 0.3 * @moveSpeed, 0
		var fall = function(ease){
			var tx, ty = @tileX, @tileY + 1
			@setTile(tx, ty)
			@replaceTweenAction {
				name = "falling",
				duration = time,
				y = @game.tileToCenterPos(tx, ty).y,
				ease = ease,
				doneCallback = function(){
					fallTiles++
					if(@isTileEmptyToFall(@tileX, @tileY + 1)){
						time = math.max(0.3 * @moveSpeed * 0.5, time * 0.8)
						fall(Ease.LINEAR)					
					}else{
						@falling = false
					}
				}.bind(this),
			}
		}.bind(this)
		fall(Ease.LINEAR) // CUBIC_IN)
	},
	
	jump = function(callback){
	},
	
	canFalling = function(){
		return !@jumping && !@falling 
			&& @isTileEmptyToFall(@tileX, @tileY + 1)
			&& @getTileType(@tileX, @tileY) != TILE_STAIRS
	},
	
	update = function(){
		if(@canFalling()){
			@startFalling()
			return
		}
	},
	
	stopBreathing = function(){
		@centerSprite()
		@sprite.replaceTweenAction {
			name = "breathing",
			duration = 0.1,
			scale = 0.9,
		}
	},
	
	breathing = function(speed){
		@centerSprite()
		speed && @breathingSpeed = speed
		var anim = function(){
			var action = SequenceAction(
				TweenAction {
					duration = 1.1 * math.random(0.9, 1.1) / @breathingSpeed,
					scale = 0.94,
					ease = Ease.CIRC_IN_OUT,
				},
				TweenAction {
					duration = 0.9 * math.random(0.9, 1.1) / @breathingSpeed,
					scale = 0.9,
					ease = Ease.CIRC_IN_OUT,
				},
			)
			action.name = "breathing"
			action.doneCallback = anim
			@sprite.replaceAction(action)
		}.bind(this)
		anim()
	},
	
	attack = function(side, speed, callback){
		@stopBreathing()
		// @centerSprite()
		// @sprite.pos = @idealPos
		if(functionOf(side)){
			side, speed, callback = null, null, side
		}else if(functionOf(speed)){
			speed, callback = null, speed
		}
		speed && @attackSpeed = speed
		var pos2 = @idealPos + vec2(128 * 0.2 * (side || 1), 0)
		var anim = function(){
			@sprite.replaceTweenAction {
				name = "attack",
				duration = 0.15 * math.random(0.9, 1.1) / @breathingSpeed,
				pos = pos2,
				angle = math.random(-10, 10),
				ease = Ease.QUINT_IN,
				doneCallback = function(){
					// print "attack mid, attackCallback: ${@attackCallback}"
					@sprite.replaceTweenAction {
						name = "attack",
						duration = 0.8 * math.random(0.9, 1.1) / @breathingSpeed,
						pos = @idealPos,
						angle = 0,
						ease = Ease.CIRC_IN_OUT,
						doneCallback = callback // anim
					}
					@attackCallback()
				}.bind(this)
			}
		}.bind(this)
		anim()
	},
}