Game4X = extends BaseGame4X {
	__object = {
		time = 0,
		tiles = {},
		tileEnt = {},
		oldViewTilePosX = -1,
		oldViewTilePosY = -1,
		player = null,
		lightMask = null,
		following = null,
		followTileX = -1,
		followTileY = -1,
	},
	
	__construct = function(){
		super()
		@size = stage.size
		@centerViewPos = @size/2
		
		@bg = Sprite().attrs {
			resAnim = res.get("bg-start"),
			pivot = vec2(0.5, 0),
			pos = vec2(@width/2, 0),
			priority = 0,
			parent = this,
		}
		@bg.scale = @width / @bg.width
		
		@view = Actor().attrs {
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			// scale = 0.9,
			priority = 1,			
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
			scale = 6.0,
			priority = 10,
			parent = this,
		}
		@lightMask.updateDark()
		
		if(false)
			@lightMask.animateLight(2.5, 2, function(){
				@lightMask.animateLight(0.5, 20, function(){
					print "ligth off"			
				}.bind(this))
			}.bind(this))
		else
			@lightMask.animateLight(2.5)
		
		@initMap("testmap")
		
		@addUpdate(@update.bind(this))
		
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
			if(ev.target is Tile){
				// print "tile clicked: ${ev.target.tileX}, ${ev.target.tileY}"
				@movePlayerToTile(ev.target.tileX, ev.target.tileY)
				return
			}
			if(ev.target is Monster){
				// print "monster clicked: ${ev.target.name}"
				@movePlayerToTile(ev.target.tileX, ev.target.tileY)
				return
			}
			if(ev.target is Player){
				// print "player clicked: ${ev.target.name}"
				@movePlayerToTile(ev.target.tileX, ev.target.tileY)
				return
			}
			print "unknown clicked: ${ev.localPos}"
			
			// var pos = @toLocalPos(@player)
			// var touch = ev.localPos
		}.bind(this))
		
		if(false){
			var draging = null
			@addEventListener(TouchEvent.START, function(ev){
				draging = ev.localPosition
			}.bind(this))
			
			@addEventListener(TouchEvent.MOVE, function(ev){
				if(draging){
					var offs = ev.localPosition - draging
					@view.pos += offs
					draging = ev.localPosition
				}
			}.bind(this))
			
			@addEventListener(TouchEvent.END, function(ev){
				draging = null
			}.bind(this))
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
				}.bind(this)
			}
		}.bind(this)) */
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
	},

	movePlayerToTile = function(tx, ty){
		var px, py = @player.tileX, @player.tileY
		var dx = tx > px ? 1 : tx < px ? -1 : 0
		var dy = ty > py ? 1 : ty < py ? -1 : 0
		if(dx == 0 && dy == 0 && (@player.moving || @player.jumping || @following)){
			var dx = px - @player.prevTileX
			var dy = py - @player.prevTileY
			print "player auto continue move: ${dx}, ${dy}"
			// @movePlayerToTile(@player.tileX + dx, @player.tileY + dy)
		}
		@player.moveToSide(dx, dy)
	},
	
	toLocalPos = function(child, pos){
		pos || pos = vec2(0, 0)
		for(var cur = child; cur && cur !== this;){
			pos = cur.local2global(pos)
			cur = cur.parent
		}
		cur || throw "${child} is not child of ${this}"
		return pos
	},
	
	initEntTilePos = function(ent, tx, ty){
		DEBUG && assert(!@tileEnt["${tx}-${ty}"])
		ent.tileX, ent.tileY = tx, ty
		ent.pos = @tileToCenterPos(tx, ty)
		@tileEnt["${tx}-${ty}"] = ent
	},
	
	setEntTile = function(ent, tx, ty){
		var key = "${ent.tileX}-${ent.tileY}"
		DEBUG && assert(@tileEnt[key] === ent, "tile busy at ${ent.tileX}x${ent.tileY} by ${@tileEnt[key].tileX}x${@tileEnt[key].tileY}")
		delete @tileEnt[key]
		ent.prevTileX, ent.prevTileY = ent.tileX, ent.tileY
		ent.tileX, ent.tileY = tx, ty
		@tileEnt["${tx}-${ty}"] = ent
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
	
	/* getEntitiesInArea = function(ax, ay, bx, by, ignoreEnt){
		var entList, entLayerIndices = {}, [LAYER_MONSTERS, LAYER_PLAYER]
		for(var _, i in entLayerIndices){
			for(var _, ent in @layers[i]){
				if(ent.tileX >= ax && ent.tileX <= bx
					&& ent.tileY >= ay && ent.tileY <= by)
				{
					ent !== ignoreEnt && entList[ent] = true
				}
			}
		}
		return entList
	}, */
	
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
	
	getTile = function(x, y){
		return @tiles[x][y]
	},
	
	updateTiledmapViewport = function(ax, ay, bx, by){
		for(var y = ay; y <= by; y++){
			for(var x = ax; x <= bx; x++){
				var tile = @getTile(x, y)
				if(!tile){
					var type = @getTileType(x, y)
					switch(type){
					default:
						var tileName = "tile-00";
						break;
						
					case TILE_GRASS:
						var tileName = "tile-01";
						break;
						
					case TILE_CHERNOZEM:
						var tileName = sprintf("tile-%02d", math.round(@getTileRandom(x, y, 2, 4)));
						break;
						
					case TILE_STAIRS:
						var tileName = "tile-05";
						break;
					}
					// print "create tile ${x}x${y}, type: ${type}, name: ${tileName}"
					var pos = @tileToPos(x, y)
					tile = Tile().attrs {
						resAnim = res.get(tileName),
						pivot = vec2(0, 0),
						pos = pos,
						priority = y * @tiledmapWidth + x,
						tileX = x,
						tileY = y,
						tileType = type,
						parent = @layers[LAYER_TILES],
					}
					;(@tiles[tile.tileX] || @tiles[tile.tileX] = {})[tile.tileY] = tile
				}
				tile.time = @time
			}
		}
	},
	
	tiledmapPlayerMap = {
		0: 1,
	},
	
	tiledmapMonsterMap = {
		8: 3,
		10: 1,
		9: 2,
	},
	
	addTilemapEntity = function(x, y, type){
		if(type in @tiledmapMonsterMap){
			var name = sprintf("monster-%02d", @tiledmapMonsterMap[type])
			var monster = Monster(this, name).attrs {
				// pos = @tileToCenterPos(x, y),
				parent = @layers[LAYER_MONSTERS],
			}
			@initEntTilePos(monster, x, y)
			return
		}
		if(type in @tiledmapPlayerMap){
			@player && throw "player is already exist"
			
			var name = sprintf("player-%02d", @tiledmapPlayerMap[type])
			@player = Player(this, name).attrs {
				// pos = @tileToCenterPos(x, y),
				parent = @layers[LAYER_PLAYER],
			}
			@initEntTilePos(@player, x, y)
			@centerViewToTile(x, y)
			return
		}
		throw "unknown entity tilemap type: ${type}"
	},
	
	markTileVisibility = function(tile, visible){
		if(!visible){
			// print "DELETE tile ${tile.tileX}x${tile.tileY}, type: ${tile.tileType}, name: ${tile.resAnim.name}"
			delete @tiles[tile.tileX][tile.tileY]
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
			var tx, ty = @player.tileX, @player.tileY
			if(@followTileX != tx || @followTileY != ty){
				@followTileX, @followTileY = tx, ty
				var pos = -(@tileToCenterPos(tx, ty) - @centerViewPos / @view.scale) * @view.scale
				@following = @view.replaceTweenAction {
					name = "following",
					duration = 0.7,
					pos = pos,
					ease = Ease.LINEAR,
					doneCallback = function(){
						@following = false
					}.bind(this),
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
		@time = ev.time
		@followPlayer()
		for(var i, layer in @layers){
			for(var _, obj in layer){
				"update" in obj && obj.update()
			}
		}
	},
}