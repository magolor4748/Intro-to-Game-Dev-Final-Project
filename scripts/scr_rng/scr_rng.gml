function xorshift_randomise() {
	global.rng_state = randomise();
	xorshift_once();
}

function xorshift_once() {
	global.rng_state ^= global.rng_state << 13;
	global.rng_state ^= ((global.rng_state & $7fff_ffff_ffff_ffff) >> 7) | ((global.rng_state < 0) * $0100_0000_0000_0000);
	global.rng_state ^= global.rng_state << 17;
}

function xorshift_random(n_max) {
	xorshift_once();
	return ((global.rng_state & 0x1F_FFFF_FFFF_FFFF) * n_max / 9007199254740992.0); // <- that's 0x20_0000_0000_0000
}

function xorshift_random_range(n_min, n_max) {
	return xorshift_random(n_max - n_min) + n_min;
}

function xorshift_irandom(n_max) {
	return floor(xorshift_random(n_max + 1));
}

function xorshift_irandom_range(n_min, n_max) {
	return floor(xorshift_random_range(n_min, n_max + 1));
}

function xorshift_choose(list) {
	if (is_array(list)) {
		var len = array_length(list);
		return list[xorshift_irandom(len - 1)];
	} else {
		var len = ds_list_size(list);
		return list[|xorshift_irandom(len - 1)];
	}
}
