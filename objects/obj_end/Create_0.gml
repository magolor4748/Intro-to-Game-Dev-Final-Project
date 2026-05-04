function create() {
	surface_resize(application_surface, 960, 640);
	window_set_size(960, 640);
	window_center();
}

function step() {
	if (keyboard_check_pressed(vk_space)) {
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		obj_transition.transition_to(rm_start, c_black);
	}
}

function draw() {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_colour(c_white);
	draw_set_font(fnt_main);
	draw_text(480 / 2, 320 / 2 - 16, "You win!");
	draw_text(480 / 2, 350 / 2 - 16, "Resources used:");
	draw_text(480 / 2, 380 / 2 - 16, "my poor desk");
	draw_text(480 / 2, 420 / 2 - 16, "Nyasynth (based on Meowsynth) + Element");
	draw_text(480 / 2, 460 / 2 - 16, "BitInvader");
	draw_text(480 / 2, 500 / 2 - 16, "sfxr");
	draw_text(480 / 2, 540 / 2 - 16, "LMMS");
}

create();