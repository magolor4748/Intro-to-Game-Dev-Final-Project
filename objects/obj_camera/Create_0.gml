function create() {
	x = global.plr.x + global.plr.sprite_width / 2;
	y = global.plr.y + global.plr.sprite_height / 2;
	camera_speed = .5;
	max_dist = 5;
	min_dist = camera_speed
	
	var _window_scale = 4;
	surface_resize(application_surface, 240, 160);
	window_set_size(240 * _window_scale, 160 * _window_scale);
	window_center();
}

function step() {
	target_x = global.plr.x + global.plr.sprite_width / 2;
	target_y = global.plr.y + global.plr.sprite_height / 2;
	x += clamp((target_x - x) * .3, -camera_speed, camera_speed);
	y += clamp((target_y - y) * .3, -camera_speed, camera_speed);
	x = clamp(x, target_x - max_dist, target_x + max_dist);
	y = clamp(y, target_y - max_dist, target_y + max_dist);
	if (abs(target_x - x) < min_dist) x = target_x;
	if (abs(target_y - y) < min_dist) y = target_y;
	camera_set_view_pos(view_camera[0], x - camera_get_view_width(view_camera[0]) / 2, y - camera_get_view_height(view_camera[0]) / 2);
}

create();