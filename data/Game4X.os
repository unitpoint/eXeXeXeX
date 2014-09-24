Game4X = extends BaseGame4X {
	__construct = function(){
		super()
		@size = stage.size
		
		@bg = Sprite().attrs {
			resAnim = res.get("bg-start"),
			pivot = vec2(0.5, 0),
			pos = vec2(@width/2, 0),
			priority = 0,
			parent = this,
		}
		@bg.scale = @width / @bg.width
		
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
		}

		var player = Sprite().attrs {
			resAnim = res.get("player-01"),
			pivot = vec2(0.5, 0.5),
			pos = vec2(256+256, 300),
			scale = 0.9,
			parent = this,
		}

		var lightMask = LightMask().attrs {
			// pivot = vec2(0.5, 0.5),
			pos = player.pos,
			scale = 10.0,
			priority = 100,
			parent = this,
		}
		lightMask.updateDark()
		lightMask.animateLight(1.5)
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

		var monster = Sprite().attrs {
			resAnim = res.get("monster-01"),
			pivot = vec2(0.5, 0.5),
			pos = player.pos + vec2(128*2, 0),
			scale = 0.9,
			parent = this,
		}
		monster.addAction(RepeatForeverAction(SequenceAction(
			TweenAction {
				duration = 1.1,
				scale = 0.94,
				ease = Ease.CIRC_IN_OUT,
			},
			TweenAction {
				duration = 0.9,
				scale = 0.9,
				ease = Ease.CIRC_IN_OUT,
			},
		)))

		var monster = Sprite().attrs {
			resAnim = res.get("monster-03"),
			pivot = vec2(0.5, 0.5),
			pos = player.pos - vec2(128*2, 0),
			scale = 0.9,
			parent = this,
		}
		monster.addAction(RepeatForeverAction(SequenceAction(
			TweenAction {
				duration = 1.1,
				scale = 0.94,
				ease = Ease.CIRC_IN_OUT,
			},
			TweenAction {
				duration = 0.9,
				scale = 0.9,
				ease = Ease.CIRC_IN_OUT,
			},
		)))
		
	},
}