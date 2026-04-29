function create() {
	x = global.plr.x + global.plr.sprite_width / 2;
	y = global.plr.y + global.plr.sprite_height / 2;
	camera_speed = .5;
	max_dist = 5;
	min_dist = camera_speed
	alt_targets = ds_stack_create();
	clamping = false;
	timer = 0;
	
	var _window_scale = 4;
	surface_resize(application_surface, 240, 160);
	window_set_size(240 * _window_scale, 160 * _window_scale);
	window_center();
}

function step() {
	if (timer > 0) timer--;
	if (timer == 0) clamping = true;
	if (ds_stack_empty(alt_targets)) {
		target_x = global.plr.x + global.plr.sprite_width / 2;
		target_y = global.plr.y + global.plr.sprite_height / 2;
	} else {
		clamping = false;
		target_x = ds_stack_top(alt_targets).x_pos;
		target_y = ds_stack_top(alt_targets).y_pos;
		if (ds_stack_top(alt_targets).timer > 0) ds_stack_top(alt_targets).timer--;
	}
	
	if (clamping) {
		x += clamp((target_x - x) * .3, -camera_speed, camera_speed);
		y += clamp((target_y - y) * .3, -camera_speed, camera_speed);
		x = clamp(x, target_x - max_dist, target_x + max_dist);
		y = clamp(y, target_y - max_dist, target_y + max_dist);
	} else {
		x = lerp(x, target_x, .1);
		y = lerp(y, target_y, .1);
	}
	if (abs(target_x - x) < min_dist) x = target_x;
	if (abs(target_y - y) < min_dist) y = target_y;
	camera_set_view_pos(view_camera[0], x - camera_get_view_width(view_camera[0]) / 2, y - camera_get_view_height(view_camera[0]) / 2);
	
	
	if (not ds_stack_empty(alt_targets) and ds_stack_top(alt_targets).timer == 0) {
		ds_stack_top(alt_targets).callback();
		ds_stack_pop(alt_targets);
		timer = 40;
	}
}

create();