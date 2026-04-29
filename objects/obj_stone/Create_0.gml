function reset() {
	previous_x = x;
	previous_y = y;
	position_x = x;
	position_y = y;
	moving = false;
	moving_timer = 0;
}

function move(dir) {
	puzzle.reset_square.enabled = true;
	if (moving) return;
	switch(dir) {
		case Directions.UP:
			if (place_meeting(x, y - 16, [obj_stone, obj_stone_barrier, obj_player])) return;
			y -= 16;
			break;
		case Directions.LEFT:
			if (place_meeting(x - 16, y, [obj_stone, obj_stone_barrier, obj_player])) return;
			x -= 16;
			break;
		case Directions.DOWN:
			if (place_meeting(x, y + 16, [obj_stone, obj_stone_barrier, obj_player])) return;
			y += 16;
			break;
		case Directions.RIGHT:
			if (place_meeting(x + 16, y, [obj_stone, obj_stone_barrier, obj_player])) return;
			x += 16;
			break;
	}
	audio_play_sound_ext({sound: snd_push, priority: 0, loop: false, pitch: .8 + random(.5)});
	moving = true;
}

function create() {
	reset();
	moving_max = 30;
}

function step() {
	if (moving) {
		if (moving_timer == moving_max) {
			reset();
			var square = instance_place(x, y, obj_win_square);
			if (square != noone) {
				puzzle.win();
			}
		} else {
			moving_timer += 1;
			position_x = previous_x + (x - previous_x) * (moving_timer / moving_max);
			position_y = previous_y + (y - previous_y) * (moving_timer / moving_max);
			for (var dx = -1; dx <= 1; dx++) {
				for (var dy = -1; dy <= 1; dy++) {
					instance_create_layer(position_x + 8 - 5 * sign(x - previous_x) + dx, position_y + 12 - 2 * sign(y - previous_y) + dy, "Back", obj_dust);
				}
			}
		}
	}
}

function win(square) {
	return;
}

function draw() {
	draw_sprite(sprite_index, 0, position_x, position_y);
	if (not moving and highlight) {
		draw_sprite(sprite_index, 1, position_x, position_y);
	}
}

function after_draw() {
	if (not moving and highlight) {
		highlight = false;
		draw_sprite(spr_pointers, highlight_dir, position_x, position_y);
	}
}

create();