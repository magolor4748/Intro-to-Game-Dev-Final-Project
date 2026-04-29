function duck() {
	audio_sound_gain(snd_cave, 0, 60);
	music_pausing = true;
}

function create() {
	music_pause_timer = 0;
	music_pausing = false;
}

function step() {
	if (music_pausing) {
		music_pause_timer += 1;
		if (music_pause_timer == 150) {
			music_pause_timer = 0;
			music_pausing = false;
			audio_sound_gain(snd_cave, 1, 60);
		}
	}
}

create();