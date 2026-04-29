enum Directions {
	UP,
	LEFT,
	DOWN,
	RIGHT
}

function create() {
	global.plr = id;
	global.key_collected = false;
	global.door_unlocked = false;
	global.crowbar_collected = false;
	move_speed = 2;
	sprint_speed = 3;
	sprinting = false;
	x_move = 0;
	y_move = 0;
	frozen = false;
	step_timer_max = 30;
	step_timer = step_timer_max;
	spr_ind = 0;
	facing = Directions.DOWN;
	pressed = ds_list_create()
	temp_pressed = ds_list_create();
	crowbar_offset = [
		[-2,6],
		[-2,7],
		[-2,6],
		[13,5],
		[13,6],
		[13,6],
		[3,5],
		[3,6],
		[3,6],
		[2,0],
		[2,0],
		[2,0],
	]
	audio_play_sound(snd_cave,0,true);
}

function is_colliding(place_x, place_y) {
	if place_meeting(place_x, place_y, obj_npc) {
		global.textbox.prepare_message(instance_place(place_x, place_y, obj_npc));
		return true
	};
	return place_meeting(place_x, place_y, [obj_door, obj_wall, obj_stone, obj_boulder]);
}

function check_inputs() {
	x_move = 0;
	y_move = 0;
	sprinting = false;
	if (keyboard_check_pressed(ord("W"))) {
		ds_list_add(pressed, Directions.UP);
	}
	if (keyboard_check_pressed(ord("A"))) {
		ds_list_add(pressed, Directions.LEFT);
	}
	if (keyboard_check_pressed(ord("S"))) {
		ds_list_add(pressed, Directions.DOWN);
	}
	if (keyboard_check_pressed(ord("D"))) {
		ds_list_add(pressed, Directions.RIGHT);
	}
	if (keyboard_check_released(ord("W"))) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.UP));
	}
	if (keyboard_check_released(ord("A"))) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.LEFT));
	}
	if (keyboard_check_released(ord("S"))) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.DOWN));
	}
	if (keyboard_check_released(ord("D"))) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.RIGHT));
	}

	if (keyboard_check(ord("S"))) {
		y_move = 1;
	} else if (keyboard_check(ord("W"))) {
		y_move = -1;
	}
	if (keyboard_check(ord("D"))) {
		x_move = 1;
	} else if (keyboard_check(ord("A"))) {
		x_move = -1;
	}
	if (keyboard_check(vk_shift)) {
		sprinting = true;
	}
}

function move() {
	move_x = (sprinting ? sprint_speed : move_speed) * x_move;// * (y_move != 0 ? sqrt(0.5) : 1);
	move_y = (sprinting ? sprint_speed : move_speed) * y_move;// * (x_move != 0 ? sqrt(0.5) : 1);
	while (abs(move_x) > 0 or abs(move_y) > 0) {
		if (not is_colliding(x + (move_x >= 1 ? 1 : (move_x <= -1 ? -1 : 0)), y + (move_y >= 1 ? 1 : (move_y <= -1 ? -1 : 0)))) {
			x += (move_x >= 1 ? 1 : (move_x <= -1 ? -1 : 0));
			y += (move_y >= 1 ? 1 : (move_y <= -1 ? -1 : 0));
			move_x += (move_x >= 1 ? -1 : (move_x <= -1 ? 1 : -move_x));
			move_y += (move_y >= 1 ? -1 : (move_y <= -1 ? 1 : -move_y));
		} else {
			if (not is_colliding(x + (move_x >= 1 ? 1 : (move_x <= -1 ? -1 : 0)), y)) {
				move_y = 0;
			} else if (not is_colliding(x, y + (move_y >= 1 ? 1 : (move_y <= -1 ? -1 : 0)))) {
				move_x = 0;
			} else break;
		}
	}
}

function win() {
	audio_stop_sound(snd_cave);
	audio_play_sound(snd_exit, 2, false);
	obj_transition.transition_next(c_black);
}

function interact() {
	var thing = collision_rectangle(x + sprite_width / 2 - 11, y + sprite_height - 11,
									x + sprite_width / 2 + 11, y + sprite_height + 11, obj_npc, true, true);
	if (thing != noone) {
		thing.show_text();
		return;
	}
	thing = instance_place(x, y, obj_reset_square);
	if (thing != noone) {
		thing.reset();
		return;
	}
	thing = instance_place(x, y, obj_crowbar);
	if (thing != noone) {
		thing.collect();
		crowbar();
		return;
	}
	thing = instance_place(x, y, obj_escape_rope);
	if (thing != noone) {
		win();
	}
	switch (facing) {
	case  Directions.UP:
		thing = collision_rectangle(x + sprite_width / 2 - 3, y + sprite_height - 4,
									x + sprite_width / 2 + 3, y + sprite_height - 3,
									obj_stone, false, true);
		break;
	case Directions.LEFT:
		thing = collision_rectangle(x + sprite_width / 2 - 4, y + sprite_height - 3,
									x + sprite_width / 2 - 3, y + sprite_height,
									obj_stone, false, true);
		break;
	case Directions.DOWN:
		thing = collision_rectangle(x + sprite_width / 2 - 3, y + sprite_height,
									x + sprite_width / 2 + 3, y + sprite_height + 1,
									obj_stone, false, true);
		break;
	case Directions.RIGHT:
		thing = collision_rectangle(x + sprite_width / 2 + 3, y + sprite_height - 3,
									x + sprite_width / 2 + 4, y + sprite_height,
									obj_stone, false, true);
		break;
	}
	if (thing != noone) {
		thing.move(facing);
		return;
	}
}

function highlight() {
	switch (facing) {
	case  Directions.UP:
		thing = collision_rectangle(x + sprite_width / 2 - 3, y + sprite_height - 4,
									x + sprite_width / 2 + 3, y + sprite_height - 3,
									obj_stone, false, true);
		break;
	case Directions.LEFT:
		thing = collision_rectangle(x + sprite_width / 2 - 4, y + sprite_height - 3,
									x + sprite_width / 2 - 3, y + sprite_height,
									obj_stone, false, true);
		break;
	case Directions.DOWN:
		thing = collision_rectangle(x + sprite_width / 2 - 3, y + sprite_height,
									x + sprite_width / 2 + 3, y + sprite_height + 1,
									obj_stone, false, true);
		break;
	case Directions.RIGHT:
		thing = collision_rectangle(x + sprite_width / 2 + 3, y + sprite_height - 3,
									x + sprite_width / 2 + 4, y + sprite_height,
									obj_stone, false, true);
		break;
	}
	if (thing != noone) {
		thing.highlight = true;
		thing.highlight_dir = facing;
		return;
	}
}

function crowbar() {
	global.crowbar_collected = true;
}

function step() {
	if (not frozen) {
		check_inputs();
		move();
		highlight();
		if (keyboard_check_pressed(vk_space)) {
			interact();
		}
		if (x_move == 0 and y_move == 0) {
			step_timer = step_timer_max;
		} else {
			if (--step_timer == 0) {
				step_timer = step_timer_max;
			}
			ds_list_copy(temp_pressed, pressed);
			while (ds_list_size(temp_pressed) > 0) {
				top_value = ds_list_find_value(temp_pressed, ds_list_size(temp_pressed) - 1);
				switch (top_value) {
				case Directions.LEFT:
					if (ds_list_find_index(temp_pressed, Directions.RIGHT) != -1) {
						ds_list_delete(temp_pressed, ds_list_size(temp_pressed) - 1);
						continue;
					}
					break;
				case  Directions.UP:
					if (ds_list_find_index(temp_pressed, Directions.DOWN) != -1) {
						ds_list_delete(temp_pressed, ds_list_size(temp_pressed) - 1);
						continue;
					}
					break;
				case Directions.DOWN:
					break;
				case Directions.RIGHT:			
					if (ds_list_size(temp_pressed) == 4) {
						ds_list_delete(temp_pressed, ds_list_size(temp_pressed) - 1);
						continue;
					}
					break;
				}
				facing = top_value;
				break;
			}
		}
	}
	spr_ind = [9,3,0,6][facing]
}
function draw() {
	var curr_spr = spr_ind +
			(step_timer >= step_timer_max / 4 * 3 and step_timer < step_timer_max         ? 1 :
			(step_timer >= step_timer_max / 4     and step_timer < step_timer_max / 4 * 2 ? 2 : 0));
	if (global.crowbar_collected && facing == Directions.UP) {
		draw_sprite_ext(spr_crowbar, -1, x + crowbar_offset[curr_spr][0], y + crowbar_offset[curr_spr][1],
		(facing == Directions.LEFT) ? -1 : 1, 1, 0, c_white, 1);
	}
	draw_sprite_ext(spr_player, curr_spr, x, y,
			1, 1, 0, c_white, 1);
	if (global.crowbar_collected && facing != Directions.UP) {
		draw_sprite_ext(spr_crowbar, -1, x + crowbar_offset[curr_spr][0], y + crowbar_offset[curr_spr][1],
		(facing == Directions.LEFT) ? -1 : 1, 1, 0, c_white, 1);
	}
}

create();