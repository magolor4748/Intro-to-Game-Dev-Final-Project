function swap_layers(obj) {
	if (global.plr.y + global.plr.sprite_height < obj.y + obj.sprite_height) {
		layer_add_instance("Front", obj);
	} else {
		layer_add_instance("Back", obj);
	}
}
