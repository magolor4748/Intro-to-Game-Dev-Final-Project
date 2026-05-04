function create() {
	version = xorshift_irandom(3);
	rotation = xorshift_random_range(-1, 1);
	ang = degtorad(xorshift_random(360));
	lifespan = xorshift_irandom(12);
}

function step() {
	if (lifespan <= 0) instance_destroy();
	ang += rotation;
	x += xorshift_irandom_range(-2, 2);
	y += xorshift_irandom_range(-2, 2);
	lifespan--;
}

function draw() {
	draw_sprite_ext(spr_dust, version, x, y, 1, 1, ang, c_white, 0.6 * (1 - lifespan / 12));
}

create();