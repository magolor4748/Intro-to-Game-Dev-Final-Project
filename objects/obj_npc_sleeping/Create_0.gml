// Inherit the parent event
event_inherited();

function create() {
	will_whine = false;
	whine_timer = 0;
}

function get_text() {
	if (global.rocks_opened) {
		return "Mrr? You did it? Great!\nJust let me rest up...";
	}
	if (global.door_unlocked) {
		return "See the way out yet? No?\nThat's fine... zzz...";
	}
	return "ZZZ... wake me up when you\nfind an exit...";
}

function show_text() {
	if (global.rocks_opened and global.textbox.is_visible and not will_whine) {
		audio_play_sound((random(1) > 0.5) ? snd_slap1 : snd_slap2, 1, false);
		will_whine = true;
	}
	global.textbox.prepare_message(id);
	global.textbox.make_visible();
}

function step() {
	swap_layers(self);
	if (will_whine) {
		whine_timer++;
		if (whine_timer == 15) {
			whine_timer = 0;
			will_whine = false;
			audio_play_sound_ext({sound: snd_whine, priority: 1, loop: false, pitch: .9 + random(.3)});
		}
	}
}

create();