function win() {
	puzzle.win();
	audio_pause_sound(snd_cave)
	music_pausing = true;
	audio_play_sound(snd_door, 2, false);
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
			audio_resume_sound(snd_cave);
		}
	}
}

create();