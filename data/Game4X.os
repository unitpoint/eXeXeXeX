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
			Sprite().attrs {
				resAnim = res.get(sprintf("tile-%02d", math.random(2, 4))),
				pivot = vec2(0.5, 0.5),
				pos = vec2(i*128, 300+128*3),
				parent = this,
			}
		}

		var player = Player("player-01").attrs {
			pos = vec2(256+256, 300),
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
		// lightMask.animateLight(1.5)
		lightMask.animateLight(4)
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
		
		monster.onAttackTarget = function(){
			// print "onAttackTarget"
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
	},
}