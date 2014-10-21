SpeechBubble = extends Actor {
	__construct = function(game, type, doneCallback){
		super()
		@game = game
		@type = type
		@doneCallback = doneCallback
		@touchChildrenEnabled = false
		
		@bubble = Sprite().attrs {
			resAnim = res.get("speech-bubble"),
			priority = 1,
			opacity = 0.5,
			parent = this,
		}
		@size = @bubble.size
		
		var bubbleCorner = vec2(6, 129) / vec2(156, 140)
		@pivot = bubbleCorner
		// @angle = -10
		@scale = 0.7
		
		var bubbleCenter = vec2(80, 61) / vec2(156, 140)
		@item = Sprite().attrs {
			resAnim = res.get(@game.getSlotItemResName(type)),
			pivot = vec2(0.5, 0.5),
			pos = bubbleCenter * @size,
			priority = 2,
			parent = this,
		}
		
		@_closing = false
		@opacity = 0
		@addTweenAction {
			name = "fade",
			duration = 1,
			opacity = 1,
			doneCallback = function(){
				@addTimeout(3, function(){
					@close()
				})
			},
		}
		@addEventListener(TouchEvent.CLICK, function(){
			@close()
		})
	},
	
	close = function(){
		if(!@_closing){
			@_closing = true
			@replaceTweenAction {
				name = "fade",
				duration = 1,
				opacity = 0,
				detachTarget = true,
				doneCallback = @doneCallback,
			}
		}
	},
}