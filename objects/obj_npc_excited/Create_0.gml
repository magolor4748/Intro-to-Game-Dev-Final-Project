// Inherit the parent event
event_inherited();

function get_text() {
	if (global.crowbar_collected) {
		if (instance_position(230, 360, obj_stone)) {
			return "Time for some unpacking!"
		}
		return "Where'd you find that?\nCould be helpful, though.";
	}
	if (instance_position(230, 360, obj_stone)) {
		return "If only there was\nsome way to destroy\nthat crate..."
	}
	if (global.rocks_opened) {
		return "The way is clear! And\nit even stopped raining!!";
	}
	return "Look, there's a cave-in, that\nmeans we're close! Now\nhow to get out...";
}