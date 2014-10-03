print "--"
print "[start] ${DateTime.now()}"

require "utils"

GAME_SIZE = vec2(960, 540)

var displaySize = stage.size
var scale = displaySize / GAME_SIZE
// scale = math.max(scale.x, scale.y)
scale = math.min(scale.x, scale.y)
stage.size = displaySize / scale
stage.scale = scale

// if(false)
mplayer.play { 
	sound = "music",
	looping = true,
	volume = 0.3,
}

Game4X().parent = stage

