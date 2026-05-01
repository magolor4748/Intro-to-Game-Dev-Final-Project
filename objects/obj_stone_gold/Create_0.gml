// Inherit the parent event
event_inherited();

function win(square) {
	if (not square.puzzle.won) {
		square.puzzle.win();
	}
	square.puzzle.won = true;
}