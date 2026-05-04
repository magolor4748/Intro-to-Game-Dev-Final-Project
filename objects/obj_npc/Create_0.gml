function create() {
	reset();
	moving_max = 30;
	avoid = [obj_wall, obj_door, obj_player, obj_stone, obj_stone_barrier, obj_wall_special];
}

function get_text() {
	return "Default";
}

function show_text() {
	global.textbox.prepare_message(id);
	global.textbox.make_visible();
}

function move(dir) {
	if (moving) return;
	switch(dir) {
		case Directions.UP:
			if (place_meeting(x, y - 16, avoid)) return false;
			y -= 16;
			break;
		case Directions.LEFT:
			if (place_meeting(x - 16, y, avoid)) return false;
			x -= 16;
			break;
		case Directions.DOWN:
			if (place_meeting(x, y + 16, avoid)) return false;
			y += 16;
			break;
		case Directions.RIGHT:
			if (place_meeting(x + 16, y, avoid)) return false;
			x += 16;
			break;
	}
	moving = true;
	return true;
}

function reset() {
	previous_x = x;
	previous_y = y;
	position_x = x;
	position_y = y;
	moving = false;
	moving_timer = 0;
}

function step() {
	swap_layers(self);
	if (moving) {
		if (moving_timer == moving_max) {
			reset();
		} else {
			moving_timer += 1;
			position_x = previous_x + (x - previous_x) * (moving_timer / moving_max);
			position_y = previous_y + (y - previous_y) * (moving_timer / moving_max);
		}
	}
}


function draw() {
	draw_sprite(sprite_index, -1, position_x, position_y);
}

function after_draw() {
	if (highlight and not global.textbox.is_visible) {
		draw_sprite(spr_npc_highlight, 0, position_x, position_y - 8);
	}
	highlight = false;
}

create();