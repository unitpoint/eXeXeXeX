splayer = SoundPlayer()
splayer.resources = soundRes

stage.addUpdate(function(){
	splayer.update()
})
