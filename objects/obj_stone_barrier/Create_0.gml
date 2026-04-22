function draw() {
	for (var i = 0; i < image_xscale; i++) {
		for (var j = 0; j < image_yscale; j++) {
			draw_sprite(sprite_index, -1, x + i * 16, y + j * 16);
		}
	}
}