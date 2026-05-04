function create() {
	global.textbox = self;
	is_visible = false;
	talking = false;
	talking_timer = 0;
	pitch = 1;
	text = "Default";
	textbox_width = 2000;
	textbox_height = 48;
}

function step() {
	if (is_visible) {
		if (talking) {
			talking_timer++;
			if (talking_timer == 40) {
				talking_timer = 0;
				talking = false;
			} else if (talking_timer % 8 == 0) {
				audio_play_sound_ext({sound: snd_talk, priority: 1, loop: false, pitch: pitch * (.9 + xorshift_random(1.0))});
			}
		}
		if (distance_to_point(global.plr.x, global.plr.y - 24) > 50) {
			talking_timer = 0;
			talking = false;
			is_visible = false;
			text = "Default";
		}
	}
}

function set_text(text) {
	id.text = text;
	textbox_width = string_width(text) + 12;
}

function make_visible() {
	if (not is_visible) {
		is_visible = true;
		talking = true;
	}
}

function prepare_message(npc) {
	set_text(npc.get_text());
	x = npc.x + npc.sprite_width / 2;
	y = npc.y - 24;
	pitch = npc.base_pitch;
}

function after_draw() {
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	if (is_visible) {
		draw_set_alpha(0.7);
		draw_sprite_stretched(spr_textbox, -1, x - textbox_width / 2, y - textbox_height / 2, textbox_width, textbox_height);
		draw_set_alpha(1);
		draw_set_colour(#F8941D);
		draw_text(x - textbox_width / 2 + 6, y - textbox_height / 2 + 3, text);
	}
}

create();