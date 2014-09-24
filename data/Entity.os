Entity = extends Actor {
	__object = {
		breathingSpeed = 1.0,
		attackSpeed = 1.0,
		
		centerActionHandle = null,
		onAttackTarget = null,
	},
	
	__construct = function(name){
		super()
		@sprite = Sprite().attrs {
			resAnim = res.get(name),
			pivot = vec2(0.5, 0.5),
			scale = 0.9,
			parent = this,
		}
		@pivot = vec2(0.5, 0.5)
		@size = @sprite.size 
		@sprite.pos = @idealPos = @size/2
		
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
					// print "attack mid, onAttackTarget: ${@onAttackTarget}"
					@sprite.replaceTweenAction {
						name = "attack",
						duration = 0.8 * math.random(0.9, 1.1) / @breathingSpeed,
						pos = @idealPos,
						angle = 0,
						ease = Ease.CIRC_IN_OUT,
						doneCallback = callback // anim
					}
					@onAttackTarget()
				}.bind(this)
			}
		}.bind(this)
		anim()
	},
}