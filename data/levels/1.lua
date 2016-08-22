local e = entities
return {
	e.background("level1.png"),
	e.wall(0, 632, 1024, 64),
	e.wall(0, 280, 1024, 64),
	e.wall(0, 344, 296, 288),
	e.wall(968, 344, 424, 208),
	e.wall(400, 472, 24, 160),
	e.wall(696, 472, 24, 80),
	player = e.player(448, 632),
	e.object("metaldoor", 746, 576),
	e.triggerArea(968, function(game)
		game:changeLevel(4)
	end)
}