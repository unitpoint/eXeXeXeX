AnimSprite = extends Sprite {
	__construct = function(format, start, count){
		super()
		@_format = stringOf(format) || throw "format string required"
		if(!count){
			start, count = 1, start
		}
		@_start = numberOf(start) || throw "start number required"
		@_count = numberOf(count) || throw "count number required"
		@_setup()
		@_delay = 0.1
		@_updateHandle = null
		@_curFrameNum = 0
		@doneCallback = null
		@play()
	},
	
	_setup = function(){
		@_frames = []
		for(var i = 0; i < @_count; i++){
			@_frames[] = res.get(sprintf(@_format, @_start + i))
		}
	},
	
	__get@numFrames = function(){
		return #@_frames
	},
	
	stop = function(){
		@removeTimeout(@_updateHandle)
		@_updateHandle = null
	},
	
	play = function(){
		@stop()
		// delay && @_delay = delay
		@resAnim = @_frames[@_curFrameNum = 0]
		@_updateHandle = @addUpdate(@_delay, function(){
			@_curFrameNum = (@_curFrameNum + 1) % #@_frames
			@resAnim = @_frames[@_curFrameNum]
			if(@_curFrameNum == 0){
				var doneCallback = @doneCallback
				doneCallback()
			}
		})
	},
	
	__get@delay = function(){
		return @_delay
	},
	__set@delay = function(value){
		if(value != @_delay){
			@_delay = value
			@_updateHandle.interval = @_delay
		}
	},
}