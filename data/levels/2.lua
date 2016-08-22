local e = entities

game:addTimeout(2, function()
				local entity =  e.object("cube", 440, 272)
				entity:trigger("setYSpeed", 400)
				game:addEntity("cube", entity)
			end)

return {
	e.background("level2.png"),
	e.wall(0, 632, 1024, 64),
	e.wall(0, 120, 1024, 64),
	e.wall(0, 184, 56, 448),
	e.wall(968, 184, 424, 208),
	e.wall(1024, 0, 64, 768),
	e.wall(824, 512, 200, 128),
	e.wall(-24, 512, 200, 128),
	e.wall(0, 536, 200, 128),
	e.wall(24, 560, 200, 128),
	e.wall(48, 584, 200, 128),
	e.wall(72, 608, 200, 128),
	e.wall(400, 136, 80, 128),
	e.wall(696, 336, 160, 32),
	player = e.player(120, 512),
	e.trigger(880, 516, function(game)
		for i = 0, 50 do
			game:addTimeout(i * 0.1, function()
				local entity =  e.object("cube", 440, 272)
				entity:trigger("setYSpeed", 400)
				game:addEntity("cube" .. i, entity)
			end)
		end
	end),
	e.triggerArea(968, function(game)
		game:changeLevel(3)
	end)
}