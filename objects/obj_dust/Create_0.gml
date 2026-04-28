function create() {
	version = irandom(3);
	rotation = random_range(-1, 1);
	ang = degtorad(random(360));
	lifespan = irandom(12);
}

function step() {
	if (lifespan <= 0) instance_destroy();
	ang += rotation;
	x += irandom_range(-2, 2);
	y += irandom_range(-2, 2);
	lifespan--;
}

function draw() {
	draw_sprite_ext(spr_dust, version, x, y, 1, 1, ang, c_white, 1);
}

create();