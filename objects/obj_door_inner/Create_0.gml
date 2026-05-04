original_x = x;
original_y = y;

puzzle_settings.win = destroy_self;

function draw() {
	draw_sprite(sprite_index, spr_ind, original_x, original_y);
}

// Inherit the parent event
event_inherited();

global.door_unlocked = false;