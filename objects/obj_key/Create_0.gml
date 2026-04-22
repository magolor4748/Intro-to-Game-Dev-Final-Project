function be_collected() {
	audio_play_sound(snd_push, 0, false);
	global.key_collected = true
	instance_deactivate_object(self)
}

function step() {
	if (place_meeting(x, y, global.plr)) {
		be_collected();
	}
}