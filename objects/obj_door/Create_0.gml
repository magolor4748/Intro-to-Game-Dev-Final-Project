function create() {
	instance_create_layer(x + puzzle_offset[0] * 16, y + puzzle_offset[1] * 16, "Back", obj_stone_puzzle, puzzle_settings);
}

create();