function create() {
	timer = 1000;
	to_next = false;
	to_prev = false;
	target = noone;
	col = c_black;
}

function transition_next(c) {
	to_next = true;
	timer = 50;
	col = c;
}

function transition_prev(c) {
	to_prev = true;
	timer = 50;
	col = c;
}

function transition_to(rm, c) {
	target = rm;
	timer = 50;
	col = c;
}

function step() {
	if (timer < 500) {
		if (to_next or to_prev or target != noone) {
			timer--;
			if (timer == 0) {
				if (to_next) room_goto_next();
				else if (to_prev) room_goto_previous();
				else room_goto(target);
			}
			if (timer == -50) {
				to_next = false;
				to_prev = false;
				target = noone;
				timer = 1000;
			}
		}
	}
}

function after_draw() {
	if (timer < 500) {
		draw_set_colour(col);
		draw_set_alpha(1 - abs(timer) / 50);
		show_debug_message(1 - abs(timer) / 50);
		show_debug_message(camera_get_view_width(view_camera[0]))
		draw_rectangle(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]),
		camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]),
		camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]), false);
		draw_set_alpha(1);
	}
}

create();