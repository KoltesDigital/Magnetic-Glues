local e = entities
return {
	e.background("level3.png"),
	e.wall(0, 632, 1024, 64),
	e.wall(0, 280, 1024, 64),
	e.wall(0, 344, 56, 288),
	e.wall(704, 344, 424, 288),
	player = e.player(120, 632),
}