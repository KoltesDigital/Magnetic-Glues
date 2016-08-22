local e = entities
return {
	e.background("level4.png"),
	e.wall(0, 672, 1024, 64),
	e.wall(0, 120, 1024, 64),
	e.wall(0, 0, 56, 768),
	e.wall(968, 0, 424, 392),
	e.wall(968, 472, 424, 400),
	player = e.player(120, 493),
	e.object("bar", 512, 493),
	e.triggerArea(968, function(game)
		game:changeLevel(2)
	end)
}