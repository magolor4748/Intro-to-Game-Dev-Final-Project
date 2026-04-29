// Inherit the parent event
event_inherited();

function get_text() {
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
	if (global.rocks_opened) {
		return "The way is clear! And\nit even stopped raining!!";
	}
	return "Look, there's a cave-in, that\nmeans we're close! Now\nhow to get out...";
}