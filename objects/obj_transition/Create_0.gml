function create() {
	timer = 1000;
	max_timer = 160;
	transition_point = 80;
	transition_rope = false;
	to_next = false;
	to_prev = false;
	target = noone;
	col = c_black;
	scale = 1;
}

function transition_next(c) {
	if (timer <= max_timer) return;
	transition_rope = (room == rm_main);
	to_next = true;
	to_prev = false;
	target = noone;
	timer = max_timer;
	col = c;
	if (room == rm_main) {
		global.plr.freeze();
		global.plr.frozen_timer = max_timer;
	}
}

function transition_prev(c) {
	if (timer <= max_timer) return;
	transition_rope = (room == rm_main);
	to_next = false;
	to_prev = true;
	target = noone;
	timer = max_timer;
	col = c;
	if (room == rm_main) {
		global.plr.freeze();
		global.plr.frozen_timer = max_timer;
	}
}

function transition_to(rm, c) {
	if (timer <= max_timer) return;
	transition_rope = (room == rm_main);
	to_next = false;
	to_prev = false;
	target = rm;
	timer = max_timer;
	col = c;
	if (room == rm_main) {
		global.plr.freeze();
		global.plr.frozen_timer = max_timer;
	}
}

function step() {
	scale = (room == rm_main) ? 1 : 2;
	if (timer <= max_timer) {
		if (to_next or to_prev or target != noone) {
			timer--;
			if (timer == transition_point) {
				if (to_next and room != rm_end) room_goto_next();
				else if (to_prev and room != rm_main) room_goto_previous();
				else if (target) room_goto(target);
				if (room == rm_main and not global.plr.frozen) {
					global.plr.freeze();
					global.plr.frozen_timer = transition_point;
				}
			}
			if (timer == 0) {
				to_next = false;
				to_prev = false;
				target = noone;
				timer = 1000;
			}
		}
	}
}

function after_draw() {
	if (transition_rope) {
		if (timer <= transition_point) {
			draw_set_colour(col);
			draw_set_alpha(timer / 80);
			draw_rectangle(0, 0, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), false);
			draw_set_alpha(1);
		} else if (timer <= max_timer) {
			var temp = max_timer - timer;
			draw_set_colour(#888800);
			col = #888800;
			draw_set_alpha(min(temp, 16) / 16 * 0.3);
			draw_rectangle(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]), camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]), false);
			draw_set_alpha(1);
			draw_rectangle(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]),  camera_get_view_x(view_camera[0]) +  camera_get_view_width(view_camera[0]), camera_get_view_y(view_camera[0]) - 120 * scale + 16 * scale * floor(temp / 4), false);
			draw_sprite_ext(spr_transition_rope, 0, camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]) - 120 * scale + 16 * scale * floor(temp / 4), scale, scale, 0, c_white, 1);
		}
	} else {
		if (timer <= transition_point) {
			var temp = timer;
			var temp_y = 16 * scale * floor(temp / 8);
			for (var i = 0; i < ceil(camera_get_view_width(view_camera[0]) / 16 * scale); i++) {
				draw_sprite_ext(spr_transition, temp % 8, camera_get_view_x(view_camera[0]) + 16 * scale * i, camera_get_view_y(view_camera[0]) + temp_y, scale, scale, 0, c_white, 1);
			}
			temp_y -= 16 * scale;
			while (temp_y >= 0) {
				for (var i = 0; i < ceil(camera_get_view_width(view_camera[0]) / 16 * scale); i++) {
					draw_sprite_ext(spr_transition, 7, camera_get_view_x(view_camera[0]) + 16 * scale * i, camera_get_view_y(view_camera[0]) + temp_y, scale, scale, 0, c_white, 1);
				}
				temp_y -= 16 * scale;
			}
		} else if (timer <= max_timer) {
			var temp = max_timer - timer;
			var temp_y = 16 * scale * floor(temp / 8);
			for (var i = 0; i < ceil(room_width / 16 * scale); i++) {
				draw_sprite_ext(spr_transition, camera_get_view_x(view_camera[0]) + temp % 8, camera_get_view_y(view_camera[0]) + 16 * scale * i, temp_y, scale, scale, 0, c_white, 1);
			}
			temp_y -= 16 * scale;
			while (temp_y >= 0) {
				for (var i = 0; i < ceil(room_width / 16 * scale); i++) {
					draw_sprite_ext(spr_transition, 7, camera_get_view_x(view_camera[0]) + 16 * scale * i, camera_get_view_y(view_camera[0]) + temp_y, scale, scale, 0, c_white, 1);
				}
				temp_y -= 16 * scale;
			}
		}
	}
}

create();