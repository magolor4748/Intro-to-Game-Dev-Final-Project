function create() {
	frame = 0;
}

function collect() {
	audio_play_sound(snd_snap, 1, false);
	instance_destroy(id, true);
}

function step() {
	frame = (frame + 1) % 20;
}

function draw() {
	draw_self();
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(spr_shine, floor(frame / 5), x + 8, y + 8, 1, 1, 0, c_white, 0.4);
	gpu_set_blendmode(bm_normal);
}

create();