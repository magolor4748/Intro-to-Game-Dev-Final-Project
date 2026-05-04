function create() {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(fnt_main);
	xorshift_randomise();
	
	timer = 50;
	timer_max = 60;
	phase = -1;
}

function step() {
	switch (phase) {
	case -1:
		break;
	case 0:
		break;
	default:
		if (keyboard_check_pressed(vk_space)) {
			audio_stop_sound(snd_exit);
			obj_transition.transition_next(c_black);
		}
	}
	if (timer >= 0) {
		timer++;
		if (timer == timer_max) {
			phase++;
			if (phase == 0) timer = 0
			else timer = -1;
		}
	}
}

function draw() {
	switch (phase) {
	case -1:
		break;
	case 0:
		draw_sprite_ext(spr_title, -1, room_width / 2, floor(room_height * 0.2), timer / timer_max, 1, 0, c_white, 1);
		break;
	default:
		draw_sprite_ext(spr_title, -1, room_width / 2, floor(room_height * 0.2), 1, 1, 0, c_white, 1);
		draw_set_colour(c_white);
		draw_text(240, 190, "After seeking refuge from the storm,");
		draw_text(240, 210, "You and your crew find yourselves stuck");
		draw_text(240, 230, "Within some ancient mechanism!");
		draw_text(240, 270, "Press Space or Z to Start!");
	}
}

create();