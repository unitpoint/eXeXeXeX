Door = extends Tile {
	STATE_CLOSED = 0,
	STATE_OPENING = 1,
	STATE_OPENED = 2,
	STATE_CLOSING = 3,

	__construct = function(game, x, y){
		super(game, x, y)
		@priority = TILE_PRIORITY_DOOR
		@front.priority = @PRIORITY_FRONT_DOOR
		// @front.priority = 5
		@handle = Sprite().attrs {
			resAnim = res.get(TILES_INFO[@frontType].handle),
			pivot = vec2(0.51, 0.51),
			pos = @size / 2,
			priority = 2,
			parent = @front,
		}
		@handleShadow = Sprite().attrs {
			resAnim = res.get(TILES_INFO[@frontType].handleShadow),
			pivot = @handle.pivot,
			pos = @handle.pos + vec2(@width * 0.02, @height * 0.05),
			opacity = 0.5,
			priority = 1,
			parent = @front,
		}
		@openY = -@height
		@handleAction = null
		@timeoutHandle = null
		@state = @STATE_CLOSED
	},
	
	__get@openState = function(){
		return @front.y / @openY
	},
	
	__get@isEmpty = function(){
		return @state != @STATE_CLOSED
	},
	
	open = function(){
		if(@state == @STATE_OPENING || @state == @STATE_OPENED){
			return
		}
		@state = @STATE_OPENING
		@removeTimeout(@timeoutHandle); @timeoutHandle = null
		@handleAction.target.removeAction(@handleAction)
		
		var destAngle = 360*2.3
		@handleAction = @handle.addTweenAction {
			duration = (1 - @handle.angle / destAngle) * 1.0,
			angle = destAngle,
			ease = Ease.CUBIC_IN_OUT,
			tickCallback = function(){
				@handleShadow.angle = @handle.angle
			}.bind(this),
			doneCallback = function(){
				@back.visible = true
				@game.updateTiledmapShadowViewport(@tileX-1, @tileY-1, @tileX+1, @tileY+1)
				@handleAction = @front.addTweenAction {
					duration = 1.0, // (1 - @openState) * 1.0,
					y = @openY,
					ease = Ease.CUBIC_IN_OUT,
					doneCallback = function(){
						@handleAction = null
						@state = @STATE_OPENED
						@timeoutHandle = @addTimeout(1.0, function(){
							@close()
						}.bind(this))
					}.bind(this),
				}
			}.bind(this),
		}
	},
	
	close = function(){
		if(@state == @STATE_CLOSING || @state == @STATE_CLOSED){
			return
		}
		@state = @STATE_CLOSING
		@removeTimeout(@timeoutHandle); @timeoutHandle = null
		@handleAction.target.removeAction(@handleAction)
		
		@timeoutHandle = @addTimeout(0.4, function(){
			@timeoutHandle = null
			var ent = @game.getTileEnt(@tileX, @tileY)
			if(ent){
				@open()
			}
		}.bind(this))
		
		@handleAction = @front.addTweenAction {
			duration = 1.0,
			y = 0,
			ease = Ease.CUBIC_IN_OUT,
			doneCallback = function(){
				@back.visible = false
				@state = @STATE_CLOSED
				@game.updateTiledmapShadowViewport(@tileX-1, @tileY-1, @tileX+1, @tileY+1)
				@handleAction = @handle.addTweenAction {
					duration = 1.0,
					angle = 0,
					ease = Ease.CUBIC_IN_OUT,
					tickCallback = function(){
						@handleShadow.angle = @handle.angle
					}.bind(this),
					doneCallback = function(){
						@handleAction = null
					}.bind(this),
				}
			}.bind(this),
		}
	},
	
	pickByEnt = function(ent){
		@open()
	},
}