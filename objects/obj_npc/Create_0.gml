function create() {
}

function get_text() {
	return "Default";
}

function show_text() {
	global.textbox.prepare_message(id);
	global.textbox.make_visible();
}

function step() {
	swap_layers(self);
}

create();