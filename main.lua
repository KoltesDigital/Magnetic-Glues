--debugging = true

require("constants")
require("src/game")

function love.load()
	game = Game.new()
	
	game:loadLevel(1)
end

function love.keypressed(key, unicode)
	game:keyPressed(key, unicode)
end

function love.keyreleased(key, unicode)
	game:keyReleased(key, unicode)
end

function love.mousepressed(x, y, button)
	game:mousePressed(x, y, button)
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:render()
end