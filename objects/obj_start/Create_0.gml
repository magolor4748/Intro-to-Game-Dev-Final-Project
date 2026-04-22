function create() {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_colour(c_white);
	draw_set_font(fnt_main);
}

function step() {
	if (keyboard_check_pressed(vk_space)) {
		audio_stop_sound(snd_exit);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		room_goto(rm_main);
	}
}

function draw() {
	draw_text(480 / 2, 320 / 2 - 16, "Cave Narrative");
	draw_text(480 / 2, 380 / 2 - 16, "After seeking refuge from the storm,");
	draw_text(480 / 2, 420 / 2 - 16, "You and your crew find yourselves stuck");
	draw_text(480 / 2, 460 / 2 - 16, "Within some ancient mechanism!");
	draw_text(480 / 2, 500 / 2 - 16, "Space to start, interact");
}

create();