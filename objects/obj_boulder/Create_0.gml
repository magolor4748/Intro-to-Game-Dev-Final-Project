// Inherit the parent event
event_inherited();

function reset() {}

function after_draw() {
	if (highlight) {
		draw_sprite(sprite_index, highlight, x, y);
		highlight = false;
	}
}