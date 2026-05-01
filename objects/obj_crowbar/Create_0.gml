// Inherit the parent event
event_inherited();

function collect() {
	global.plr.cheering = true;
	global.plr.freeze();
	global.plr.frozen_timer = 100;
	audio_play_sound(snd_snap, 1, false);
	instance_destroy(id, true);
}