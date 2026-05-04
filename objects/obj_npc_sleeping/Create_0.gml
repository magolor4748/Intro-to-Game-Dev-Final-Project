// Inherit the parent event
event_inherited();

function create() {
	reset();
	moving_max = 30;
	will_whine = false;
	whine_timer = 0;
	global.textbox.push_cat = false;
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
	if (global.textbox.push_cat or (global.rocks_opened and global.textbox.is_visible) and not will_whine) {
		global.textbox.push_cat = true;
		move(global.plr.facing);
		audio_play_sound(xorshift_choose([snd_slap1, snd_slap2]), 1, false);
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
			audio_play_sound_ext({sound: snd_whine, priority: 1, loop: false, pitch: .9 + xorshift_random(.3)});
		}
	}
	
	if (moving) {
		if (moving_timer == moving_max) {
			reset();
		} else {
			moving_timer += 1;
			position_x = previous_x + (x - previous_x) * (moving_timer / moving_max);
			position_y = previous_y + (y - previous_y) * (moving_timer / moving_max);
		}
	}
}

function after_draw() {
	if (highlight and not global.textbox.is_visible) {
		draw_sprite(spr_npc_highlight, 0, position_x, position_y - 8);
	}
	if (highlight and global.textbox.push_cat and not moving) draw_sprite(spr_pointers, highlight_dir, position_x, position_y);
	highlight = false;
}

create();