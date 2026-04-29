function reset() {
	for (var i = 0; i < array_length(stone_positions); i++) {
		stones[|i].x = x + (stone_positions[i][0] * 16);
		stones[|i].y = y + (stone_positions[i][1] * 16);
		stones[|i].reset();
	}
	for (var i = 0; i < array_length(other_positions); i++) {
		others[|i].reset();
	}
}

function create() {
	if (not variable_global_exists("puzzles")) {
		global.puzzles = ds_list_create();		
	}
	ds_list_add(global.puzzles, id);
	
	reset_count = 0;
	stones = ds_list_create();
	others = ds_list_create();
	instance_create_layer(x, y, "FurtherBack",
			obj_stone_barrier, {image_xscale: puzzle_width});
	instance_create_layer(x, y + ((puzzle_height - 1) * 16), "FurtherBack",
			obj_stone_barrier, {image_xscale: puzzle_width});
	instance_create_layer(x, y + 16, "FurtherBack",
			obj_stone_barrier, {image_yscale: puzzle_height - 2});
	instance_create_layer(x + ((puzzle_width - 1) * 16), y + 16, "FurtherBack",
			obj_stone_barrier, {image_yscale: puzzle_height - 2});
	ds_list_add(stones,
		instance_create_layer(x + stone_positions[0][0] * 16, y + stone_positions[0][1] * 16, "Back",
			obj_stone_gold, {puzzle: id}));
	for (var i = 1; i < array_length(stone_positions); i++) {
		ds_list_add(stones,
			instance_create_layer(x + stone_positions[i][0] * 16, y + stone_positions[i][1] * 16, "Back",
				obj_stone, {puzzle: id}));
	}
	for (var i = 0; i < array_length(other_positions); i++) {
		ds_list_add(others,
			instance_create_layer(x + other_positions[i][1] * 16, y + other_positions[i][2] * 16, "Back",
				other_positions[i][0], {puzzle: id}));
	}
	win_square = instance_create_layer(x + win_position[0] * 16, y + win_position[1] * 16, "FurtherBack",
					obj_win_square, {puzzle: id});
	reset_square = instance_create_layer(x, y - 16, "FurtherBack",
					obj_reset_square, {puzzle: id});
}

create();