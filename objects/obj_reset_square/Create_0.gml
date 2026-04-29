function reset() {
	if (enabled) {
		puzzle.reset();
		puzzle.reset_count++;
		enabled = false;
	}
}