mplayer = SoundPlayer()
mplayer.resources = soundRes

stage.addUpdate(function(){
	mplayer.update()
})
