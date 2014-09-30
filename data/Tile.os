Tile = extends BaseTile {
	__construct = function(game, x, y){
		super(game, x, y)
		
		@frontType = @game.getFrontType(x, y)
		var frontType = @frontType == TILE_TYPE_BLOCK ? TILE_TYPE_ROCK : @frontType
		
		@backType = @game.getBackType(x, y)
		var backType = @backType == TILE_TYPE_BLOCK ? TILE_TYPE_ROCK : @backType
		
		var frontResName = @game.getTileResName("tile", frontType, x, y, TILES_INFO[frontType].variants)
		@front = Sprite().attrs {
			resAnim = res.get(frontResName),
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			priority = 2,
			parent = this
		}
		@front.scale = @size / @front.size
		
		var backResName = @game.getTileResName("tile", backType, x, y, TILES_INFO[backType].variants)
		@back = Sprite().attrs {
			resAnim = res.get(backResName),
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			priority = 1,
			parent = this
		}
		if(backType < 16)
			@back.color = Color(0.2, 0.2, 0.2)
		else
			@back.color = Color(0.7, 0.7, 0.7)
		@back.scale = @size / @back.size
		
		if(@frontType == TILE_TYPE_EMPTY){
			@front.visible = false
		}else if(@frontType != TILE_TYPE_LADDERS){
			@back.visible = false
		}
		
		@itemType = @game.getItemType(x, y)
		if(@itemType > 0){
			var itemResName = @game.getTileResName("item", @itemType, x, y, ITEMS_INFO[@itemType].variants)
			@item = Sprite().attrs {
				resAnim = res.get(itemResName),
				pivot = vec2(0.5, 0.5),
				pos = @size/2,
				priority = 3,
				parent = this,
			}
			@item.scale = @size / math.max(@item.width, @item.height)
		}
		
		@shadow = Actor().attrs {
			size = @size,
			priority = 4,
			parent = this,
		}
	},
	
	__get@isEmpty = function(){
		return @frontType == TILE_TYPE_EMPTY || @frontType == TILE_TYPE_LADDERS
	},
	
	getIsEmpty = function(x, y){
		var type = @game.getFrontType(x, y)
		if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS){
			return true
		}
		var tile = @game.getTile(x, y)
		return tile.isEmpty
	},
	
	updateShadow = function(){
		@shadow.removeChildren()
		
		var x, y = @tileX, @tileY
		@getIsEmpty(x, y) || return;
		
		var top = @getIsEmpty(x, y-1)
		var bottom = @getIsEmpty(x, y+1)
		var left = @getIsEmpty(x-1, y)
		var right = @getIsEmpty(x+1, y)
		var leftTop = @getIsEmpty(x-1, y-1)
		var rightTop = @getIsEmpty(x+1, y-1)
		var leftBottom = @getIsEmpty(x-1, y+1)
		var rightBottom = @getIsEmpty(x+1, y+1)
		
		var opacity = 0.7
		if(!top){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-left"),
				angle = 90,
				// pos = vec2(0, 0),
				pivot = vec2(0, 1),
				opacity = opacity,
				parent = @shadow
			}
			var x, size = 0, TILE_SIZE
			if(!left){
				x = TILE_FADE_SIZE
				size = size - TILE_FADE_SIZE
			}
			if(!right){
				size = size - TILE_FADE_SIZE
			}
			fade.x = x
			fade.scale = vec2(TILE_FADE_SIZE, size) / fade.size
		}
		if(!bottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-left"),
				angle = -90,
				// pos = vec2(0, 0),
				y = TILE_SIZE,
				pivot = vec2(0, 0),
				opacity = opacity,
				parent = @shadow
			}
			var x, size = 0, TILE_SIZE
			if(!left){
				x = TILE_FADE_SIZE
				size = size - TILE_FADE_SIZE
			}
			if(!right){
				size = size - TILE_FADE_SIZE
			}
			fade.x = x
			fade.scale = vec2(TILE_FADE_SIZE, size) / fade.size
		}
		if(!left){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-left"),
				angle = 0,
				// pos = vec2(0, 0),
				pivot = vec2(0, 0),
				opacity = opacity,
				parent = @shadow
			}
			var y, size = 0, TILE_SIZE
			if(!top){
				y = TILE_FADE_SIZE
				size = size - TILE_FADE_SIZE
			}
			if(!bottom){
				size = size - TILE_FADE_SIZE
			}
			fade.y = y
			fade.scale = vec2(TILE_FADE_SIZE, size) / fade.size
		}
		if(!right){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-left"),
				angle = 180,
				// pos = vec2(0, 0),
				x = TILE_SIZE,
				pivot = vec2(0, 1),
				opacity = opacity,
				parent = @shadow
			}
			var y, size = 0, TILE_SIZE
			if(!top){
				y = TILE_FADE_SIZE
				size = size - TILE_FADE_SIZE
			}
			if(!bottom){
				size = size - TILE_FADE_SIZE
			}
			fade.y = y
			fade.scale = vec2(TILE_FADE_SIZE, size) / fade.size
		}
		if(left && top && !leftTop){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-outer-left-top"),
				// pivot = vec2(0, 0),
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!left && !top){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				// pivot = vec2(0, 0),
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}
		if(right && top && !rightTop){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-outer-left-top"),
				pivot = vec2(0, 0),
				angle = 90,
				x = TILE_SIZE,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!right && !top){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				pivot = vec2(0, 0),
				angle = 90,
				x = TILE_SIZE,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}
		if(left && bottom && !leftBottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-outer-left-top"),
				// pivot = vec2(0, 0),
				y = TILE_SIZE,
				angle = -90,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!left && !bottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				// pivot = vec2(0, 0),
				y = TILE_SIZE,
				angle = -90,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}
		if(right && bottom && !rightBottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-outer-left-top"),
				// pivot = vec2(0, 0),
				x = TILE_SIZE,
				y = TILE_SIZE,
				angle = 180,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!right && !bottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				// pivot = vec2(0, 0),
				x = TILE_SIZE,
				y = TILE_SIZE,
				angle = 180,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}
	},
}