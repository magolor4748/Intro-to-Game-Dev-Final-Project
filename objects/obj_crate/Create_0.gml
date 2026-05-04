function move(dir) {
	if (global.crowbar_collected) {
		audio_play_sound(snd_smack, 1, false);
		is_destroyed = true;
		x = -9900
		y = -9900
	} else {
		audio_play_sound(xorshift_choose([snd_slap1, snd_slap2]), 1, false);
	}
}

function reset() {
	return;
}

function create() {
	original_position = [x,y];
	is_destroyed = false;
}



function draw() {
	if (is_destroyed) {
		draw_sprite(sprite_index, 1, original_position[0], original_position[1]);
	} else draw_self();
}

function after_draw() {
	if (global.crowbar_collected and highlight) {
		highlight = false;
		draw_sprite(sprite_index, 2, x, y);
	}
}

create();