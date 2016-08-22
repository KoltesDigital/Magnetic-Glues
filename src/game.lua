require("src/components")
require("src/behaviors")
require("src/entities")

Game = {}
Game.__index = Game

function Game.new()
	local self = {}
	setmetatable(self, Game)
	
	love.mouse.setVisible(false)
	
	self.world = love.physics.newWorld(-650, -650, 6500, 6500) --create a world for the bodies to exist in with width and height of 650
	self.world:setGravity(0, constants.gravity) --the x component of the gravity will be 0, and the y component of the gravity will be 700
	self.world:setMeter(constants.meter) --the height of a meter in this world will be 64px
	
	self.world:setCallbacks(function(a, b, contact) --add
		a:trigger("collisionAdded", b, contact, true)
		b:trigger("collisionAdded", a, contact, false)
	end,
	nil,
	function(a, b, contact) --remove
		a:trigger("collisionRemoved", b, contact, true)
		b:trigger("collisionRemoved", a, contact, false)
	end)
	
	world = self.world -- hacked!
	
	self.entities = {}
	self.components = {}
	self.triggers = {}
	self.triggerAreas = {}
	self.timeouts = {}
	self.time = 0
	
	return self
end

function Game:changeLevel(n)
	self.fadeTime = self.time + 255 / constants.fadeRate
	self.nextLevel = n
end

function Game:loadLevel(n)
	self.time = 0
	self.fadeTime = nil
	self.currentLevel = n

	for id, entity in pairs(self.entities) do
		entity:destroy()
	end
	
	self.entities = {}
	self.components = {}
	self.triggers = {}
	self.triggerAreas = {}
	self.timeouts = {}
	
	local level = love.filesystem.load("data/levels/" .. n .. ".lua")
	if level then
		for id, entity in pairs(level()) do
			self:addEntity(id, entity)
		end
	end
end

function Game:reloadLevel()
	self:changeLevel(self.currentLevel)
end

function Game:addEntity(id, entity)
	entity._id = id
	if self.entities[id] then
		self.entities[id]:destroy()
	end
	self.entities[id] = entity
	entity:setGame(self)
end

function Game:removeEntity(id)
	if self.entities[id] then
		self.entities[id]:destroy()
	end
	self.entities[id] = nil
end

function Game:addComponent(component)
	if not self.components[component._category] then
		local table = {}
		setmetatable(table, {__mode = "k"})
		self.components[component._category] = table
	end
	self.components[component._category][component] = true
end

function Game:removeComponent(component)
	if self.components[component._category] then
		self.components[component._category][component] = nil
	end
end

function Game:registerTrigger(x, y, fn)
	self.triggers[fn] = {x = x, y = y}
end

function Game:registerTriggerArea(x, fn)
	self.triggerAreas[fn] = x
end

function Game:addTimeout(time, fn)
	self.timeouts[fn] = time
end

function Game:trigger(event, ...)
	for id, entity in pairs(self.entities) do
		entity:trigger(event, ...)
	end
end

function Game:componentCall(category, fn, ...)
	local components = self.components[category]
	if components then
		for component in pairs(components) do
			if component[fn] then
				component[fn](component, ...)
			end
		end
	end
end

function Game:keyPressed(key, unicode)
	-- quit the game
	if key == "escape" then
		love.event.push("q")
	end 
	
	if key == "r" then
		self:reloadLevel()
	end
	
	self:componentCall("inputs", "keyPressed", key, unicode)
end

function Game:keyReleased(key, unicode)
	self:componentCall("inputs", "keyReleased", key, unicode)
end

function Game:mousePressed(x, y, button)
	self:componentCall("inputs", "mousePressed", x, y, button)
end

function Game:update(dt)
	-- avoids freezes
	if dt > 0.2 then
		return
	end
	
	self.time = self.time + dt
	
	if self.fadeTime and self.time >= self.fadeTime then
		self:loadLevel(self.nextLevel)
	end
	
	self:componentCall("inputs", "update")
	
	world:update(dt)
	
	for id, entity in pairs(self.entities) do
		if entity.toBeDestroyed then
			self:removeEntity(entity._id)
		end
	end
	
	self:componentCall("bodies", "update")
	
	for fn, time in pairs(self.timeouts) do
		self.timeouts[fn] = time - dt
		if self.timeouts[fn] <= 0 then
			self.timeouts[fn] = nil
			fn(self)
		end
	end
	
	for fn, pos in pairs(self.triggers) do
		for id, entity in pairs(self.entities) do
			if entity.behaviors.object and entity.behaviors.object.name == "cube" then
				local px, py = entity.behaviors.object.body.body:getPosition()
				if math.pow(px - pos.x, 2) + math.pow(py - pos.y, 2) < constants.triggerDistance2 then
					self.triggers[fn] = nil
					fn(self)
				end
			end
		end
	end
	
	for fn, x in pairs(self.triggerAreas) do
		local px = self.entities.player.behaviors.player.body.body:getPosition()
		if px >= x then
			self.triggerAreas[fn] = nil
			fn(self)
		end
	end
end

function Game:render()
	local color = math.min(255, self.time * constants.fadeRate)
	if self.fadeTime then
		color = math.max(0, math.min(color, (self.fadeTime - self.time) * constants.fadeRate))
	end
	love.graphics.setColor(color, color, color)
	
	for layer = 0, 4 do
		self:componentCall("images", "draw", layer)
	end
	
	if debugging then
		self:componentCall("bodies", "draw")
	end
end
