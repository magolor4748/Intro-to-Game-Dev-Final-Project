function reset() {
	if (enabled) {
		puzzle.reset();
		puzzle.reset_count++;
		enabled = false;
	}
}

function draw() {
	draw_sprite(sprite_index, enabled and highlight, x, y);
	highlight = false;
}