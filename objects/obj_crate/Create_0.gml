function move(dir) {
	if (global.crowbar_collected) {
		audio_play_sound(snd_smack, 1, false);
		is_destroyed = true;
		x = -9900
		y = -9900
	} else {
		audio_play_sound((random(1) > 0.5) ? snd_slap1 : snd_slap2, 1, false);
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

create();