// Inherit the parent event
event_inherited();

function collect() {
	global.plr.cheering = true;
	global.plr.freeze();
	global.plr.frozen_timer = 50;
	audio_play_sound(snd_get, 1, false);
	obj_duck.duck();
	global.textbox.set_text("             Got Crowbar!\nUse it to... break things?");
	global.textbox.x = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2;
	global.textbox.y = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2;
	global.textbox.make_visible();
	instance_destroy(id, true);
}