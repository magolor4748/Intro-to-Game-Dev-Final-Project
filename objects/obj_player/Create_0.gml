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
	frozen_timer = 0;
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
		[13,-6],
	]
	
	cheering = false;
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
	if (keyboard_check_pressed(ord("W")) or keyboard_check_pressed(vk_up)) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.UP));
		ds_list_add(pressed, Directions.UP);
	}
	if (keyboard_check_pressed(ord("A")) or keyboard_check_pressed(vk_left)) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.LEFT));
		ds_list_add(pressed, Directions.LEFT);
	}
	if (keyboard_check_pressed(ord("S")) or keyboard_check_pressed(vk_down)) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.DOWN));
		ds_list_add(pressed, Directions.DOWN);
	}
	if (keyboard_check_pressed(ord("D")) or keyboard_check_pressed(vk_right)) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.RIGHT));
		ds_list_add(pressed, Directions.RIGHT);
	}
	if (keyboard_check_released(ord("W")) or keyboard_check_released(vk_up)) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.UP));
	}
	if (keyboard_check_released(ord("A")) or keyboard_check_released(vk_left)) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.LEFT));
	}
	if (keyboard_check_released(ord("S")) or keyboard_check_released(vk_down)) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.DOWN));
	}
	if (keyboard_check_released(ord("D")) or keyboard_check_released(vk_right)) {
		ds_list_delete(pressed, ds_list_find_index(pressed, Directions.RIGHT));
	}
	
	switch (ds_list_top(pressed)) {
	case Directions.UP:
		y_move = -1;
		break;
	case Directions.DOWN:
		y_move = 1;
		break;
	case Directions.RIGHT:
		x_move = 1;
		break;
	case Directions.LEFT:
		x_move = -1;
		break;
	}
	
	sprinting = keyboard_check(vk_shift);
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
	var thing = instance_place(x, y, obj_reset_square);
	if (thing != noone) {
		thing.highlight = true;
		return;
	}
	
	switch (facing) {
	case  Directions.UP:
		thing = collision_rectangle(x + sprite_width / 2 - 3, y + sprite_height - 4,
									x + sprite_width / 2 + 3, y + sprite_height - 3,
									[obj_stone, obj_boulder], false, true);
		break;
	case Directions.LEFT:
		thing = collision_rectangle(x + sprite_width / 2 - 4, y + sprite_height - 3,
									x + sprite_width / 2 - 3, y + sprite_height,
									[obj_stone, obj_boulder], false, true);
		break;
	case Directions.DOWN:
		thing = collision_rectangle(x + sprite_width / 2 - 3, y + sprite_height,
									x + sprite_width / 2 + 3, y + sprite_height + 1,
									[obj_stone, obj_boulder], false, true);
		break;
	case Directions.RIGHT:
		thing = collision_rectangle(x + sprite_width / 2 + 3, y + sprite_height - 3,
									x + sprite_width / 2 + 4, y + sprite_height,
									[obj_stone, obj_boulder], false, true);
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

function freeze() {
	ds_list_clear(pressed);
	frozen = true;
}

function unfreeze() {
	frozen = false;
	cheering = false;
	if (keyboard_check(ord("W")) or keyboard_check(vk_up)) {
		ds_list_add(pressed, Directions.UP);
	}
	if (keyboard_check(ord("A")) or keyboard_check(vk_left)) {
		ds_list_add(pressed, Directions.LEFT);
	}
	if (keyboard_check(ord("S")) or keyboard_check(vk_down)) {
		ds_list_add(pressed, Directions.DOWN);
	}
	if (keyboard_check(ord("D")) or keyboard_check(vk_right)) {
		ds_list_add(pressed, Directions.RIGHT);
	}
}

function step() {
	if (frozen) {
		if (frozen_timer > 0) {
			frozen_timer--;
			if (frozen_timer == 0) unfreeze();
		}
	} else {
		check_inputs();
		move();
		highlight();
		if (keyboard_check_pressed(vk_space) or keyboard_check_pressed(ord("Z"))) {
			interact();
		}
		if (x_move == 0 and y_move == 0) {
			step_timer = step_timer_max;
		} else {
			if (--step_timer == 0) {
				step_timer = step_timer_max;
			}
		}
	}
	if (not ds_list_empty(pressed)) {
		facing = ds_list_top(pressed);
		spr_ind = [9,3,0,6][facing]
	}
}
function draw() {
	var curr_spr = cheering ? 12 : (spr_ind +
			(step_timer >= step_timer_max / 4 * 3 and step_timer < step_timer_max         ? 1 :
			(step_timer >= step_timer_max / 4     and step_timer < step_timer_max / 4 * 2 ? 2 : 0)));
	if (global.crowbar_collected and (cheering or facing == Directions.UP)) {
		draw_sprite_ext(spr_crowbar, -1, x + crowbar_offset[curr_spr][0], y + crowbar_offset[curr_spr][1],
		(facing == Directions.LEFT) ? -1 : 1, 1, 0, c_white, 1);
	}
	draw_sprite_ext(spr_player, curr_spr, x, y,
			1, 1, 0, c_white, 1);
	if (global.crowbar_collected and not cheering and facing != Directions.UP) {
		draw_sprite_ext(spr_crowbar, -1, x + crowbar_offset[curr_spr][0], y + crowbar_offset[curr_spr][1],
		(facing == Directions.LEFT) ? -1 : 1, 1, 0, c_white, 1);
	}
}

create();