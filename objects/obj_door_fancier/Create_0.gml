puzzle_settings.win = function() {
	global.rocks_opened = true;
	global.plr.freeze();
	obj_door_fancier.boom_timer = 0;
	ds_stack_push(
		obj_camera.alt_targets,
		{x_pos: 96, y_pos: 592, timer: 80, callback:
			function() {
				obj_door_fancier.x = -1000;
				obj_door_fancier.y = -1000;
				obj_door_fancier.spr_ind = 1;
				instance_destroy(obj_boom);
				global.plr.cheering = true;
				global.plr.frozen_timer = 100;
				obj_duck.duck();
				audio_play_sound(snd_door, 2, false);
			}
		},
		{x_pos: x + 64, y_pos: y + 16, timer: 40, callback:
			function() {
				audio_play_sound_ext({sound: snd_whine, priority: 1, loop: false, pitch: .9 + xorshift_random(.3)});
			}
		},
		{x_pos: x + 64, y_pos: y + 16, timer: 40, callback:
			function() {
				audio_play_sound_ext({sound: snd_whine, priority: 1, loop: false, pitch: .9 + xorshift_random(.3)});
			}
		},
		{x_pos: x + 128 - 16, y_pos: y + 16, timer: 80, callback:
			function() {
				audio_play_sound_ext({sound: snd_whine, priority: 1, loop: false, pitch: .9 + xorshift_random(.3)});
			}
		},
		{x_pos: x + 16, y_pos: y + 16, timer: 80, callback:
			function() {
				audio_play_sound_ext({sound: snd_whine, priority: 1, loop: false, pitch: .9 + xorshift_random(.3)});
			}
		}
	);
}

original_x = x;
original_y = y;

// Inherit the parent event
event_inherited();

function draw() {
	draw_sprite(sprite_index, spr_ind, original_x, original_y);
}

function step() {
	if (boom_timer == 0) {
		boom_pos = ds_list_create();
		for (var i = 0; i < 5; i++) {
			ds_list_add(boom_pos, [irandom_range(0, 128), xorshift_irandom_range(0,16)])
		}
	}
	if (boom_timer >= 0) {
		boom_timer++;
		if (boom_timer >= 5 * 32) {
			obj_door_fancier.boom_timer = -1;
			return;
		}
		if (boom_timer % 32 == 1) {
			var pos = boom_pos[|floor(boom_timer / 32)];
			instance_create_layer(original_x + pos[0], original_y + pos[1], "Front", obj_boom);
			audio_falloff_set_model(audio_falloff_none);
			audio_play_sound_at(snd_boom, -(pos[0] - 64), global.plr.y, 0, 1, 1, 1, false, 1);
		}
	}
}
	