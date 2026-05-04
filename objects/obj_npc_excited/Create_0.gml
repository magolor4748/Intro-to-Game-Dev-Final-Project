// Inherit the parent event
event_inherited();

function create() {
	reset();
	moving_max = 30;
	original_x = x;
	original_y = y;
	possible = ds_list_create();
	talk_ind = 0;
	avoid = [obj_wall, obj_door];
}

function get_text() {
	if (global.rocks_opened) {
		if (talk_ind > 3) {
			return "Just push the guy over.\nShove them over here if you have to!";
		}
		talk_ind++;
		return "The way is clear! Go get that\nloaf before we leave. Who knows\nif the doors will stay open?";
	}
	if (global.puzzles[|0].reset_count > 5) {
		if (global.crowbar_collected) {
			if (instance_position(230, 360, obj_stone)) {
				return "If you get that box\n out of the way, then you can\nclear the rock above it!";
			}
			return "Try breaking the crate. Then,\nuse that free space for something!";
		}
		return "Hey, I noticed something to the right there...";
	}
	if (global.crowbar_collected) {
		if (instance_position(230, 360, obj_stone)) {
			return "Time for some unpacking!"
		}
		return "Where'd you find that?\nCould be helpful, though.";
	}
	if (instance_position(230, 360, obj_stone)) {
		return "If only there was\nsome way to destroy\nthat crate..."
	}
	return "Look, there's a cave-in,that\nmeans we're close to an exit!\nNow how to break through...";
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
	} else {
		var target_x = original_x;
		var target_y = original_y;
		var restriction = 2;
		if (global.rocks_opened) {
			target_x = 280;
			target_y = 128;
			retriction = 1;
		}
		if (x >= target_x - 16 * restriction) ds_list_add(possible, Directions.LEFT);
		if (x <= target_x + 16 * restriction) ds_list_add(possible, Directions.RIGHT);
		if (global.rocks_opened) {
			if (y < 207) ds_list_add(possible, Directions.DOWN);
			ds_list_add(possible, Directions.UP);
		} else {
			if (y <= target_y + 16 * restriction) ds_list_add(possible, Directions.DOWN);
			if (y >= target_y - 16 * restriction) ds_list_add(possible, Directions.UP);
		}
		move(possible[|xorshift_irandom(ds_list_size(possible) - 1)]);
		ds_list_clear(possible);
	}
}

create();