StandFlame = extends Actor {
	__construct = function(game, tile){
		super()
		@game = game
		@parent = tile
		@pos = vec2(tile.width/2, tile.height)
		
		@stand = Sprite().attrs {
			resAnim = res.get("fire-stand"),
			pivot = vec2(0.5, 1),
			priority = 1,
			parent = this,
		}
		
		@flame = AnimSprite("flame-%02d", 14).attrs {
			pivot = vec2(0.5, 1),
			x = 0,
			y = 19 - @stand.height,
			priority = 0,
			parent = this,
		}
		
		@touchEnabled = false
		@touchChildrenEnabled = false
		
		var lightTileRadius = 3
		var lightTileRadiusScale = 1.5 // dependence on light name
		var lightRadius = lightTileRadius * lightTileRadiusScale * TILE_SIZE
		var lightColor = Color(1.0, 0.95, 0.7)
		@light = Light().attrs {
			name = "light-01",
			shadowColor = Color(0.2, 0.2, 0.2),
			color = lightColor,
			radius = lightRadius,
			// pos = @pos + @size / 2,
		}
		@game.addLight(@light)
		// print "StandFlame.new: ${@parent.tileX}x${@parent.tileY}"
		
		var handle = @addUpdate(0.05, function(){
			var r = lightColor.r * math.random(0.9, 1.1)
			var g = lightColor.g * math.random(0.9, 1.1)
			var b = lightColor.b * math.random(0.9, 1.1)
			@light.color = Color(r, g, b)
			@light.pos = @parent.pos + vec2(math.random(0.4, 0.6), math.random(0.4, 0.6)) * TILE_SIZE
			// print "update light color: ${@light.color}, pos: ${@light.pos}"
		})
	},
	
	cleanup = function(){
		// print "StandFlame.cleanup: ${@parent.tileX}x${@parent.tileY}"
		@game.removeLight(@light)
	},
}