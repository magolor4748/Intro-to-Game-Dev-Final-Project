function create() {
	frame = 0;
}

function step() {
	swap_layers(self);
	frame = (frame + 1) % 20;
}

function after_draw() {
	if(instance_nearest(0, 0, obj_npc_excited).y < 223 and instance_nearest(0, 0, obj_npc_sleeping).y < 223) {
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(spr_shine, floor(frame / 5), 223, 142, 1, 1, 0, c_white, 0.6);
		gpu_set_blendmode(bm_normal);
	}
}

create();