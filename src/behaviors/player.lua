local Player = {}
Player._name = "player"
Player.__index = Player

function behaviors.player(x, y)
	local self = {}
	setmetatable(self, Player)
	
	self.animation = love.filesystem.load("data/animations/player.lua")()
	
	self.image = components.image(self.animation.image, self.animation.x, self.animation.y, 1)
	
	self.gun = components.image("gun.png", -16, -16, 2)
	
	self.body = components.body("rect", self.animation.x + self.animation.width/2, self.animation.y + self.animation.height/2, self.animation.width, self.animation.height)
	self.body:setFixedRotation()
	self.body:setDynamic()
	
	self.body:connect("positionChanged", function(x, y)
		self.image:setPosition(x, y)
		self.gun:setPosition(x, y - constants.armDistance)
	end)
	
	self.cursor = components.image("cursor.png", -16, -16, 3)
	
	self.input = components.input()
	
	self.input:connect("speedXChanged", function(x)
		self.body:setXSpeed(x)
	end)
	self.input:connect("speedYChanged", function(...)
		self.body:setYSpeed(...)
	end)
	self.input:connect("mousePositionChanged", function(mx, my)
		self.cursor:setPosition(mx, my)
		local x, y = self.body:getPosition()
		local angle = math.atan2(my - y + constants.armDistance, mx - x)
		self.gun:setAngle(angle)
		self.image:setFlipped(mx < x)
	end)
	self.input:connect("mousePressed", function(x, y, button)
		local id = (button == "l") and "north" or "south"
		local x, y = self.body:getPosition()
		local angle = self.gun:getAngle()
		local entity = entities.glue(x + math.cos(angle) * constants.gunLength, y - constants.armDistance + math.sin(angle) * constants.gunLength, angle, button == "l")
		self.entity.game:addEntity(id, entity)
	end)
	
	self.body:setPosition(x, y)

	return self
end

function Player:setEntity(entity)
	self.entity = entity
	self.body:setData(entity)
	entity:addComponent(self.image)
	entity:addComponent(self.gun)
	entity:addComponent(self.body)
	entity:addComponent(self.cursor)
	entity:addComponent(self.input)
end

function Player:destroy()
	self.entity = nil
	self.body:destroy()
end

function Player:collisionAdded(other, contact, direct)
	if not other.behaviors.glue then
		local nx, ny = contact:getNormal()
		if not direct then
			nx, ny = -nx, -ny
		end
		local angle = math.atan2(ny, nx)
		
		if math.abs(angle - math.pi/2) < math.pi/4 then
			self.input:addGround()
		elseif math.abs(angle) < math.pi/4 then
			self.input:wall(true)
		elseif math.abs(angle) > 3*math.pi/4 then
			self.input:wall(false)
		end
	end
end

function Player:collisionRemoved(other, contact, direct)
	if not other.behaviors.glue then
		local nx, ny = contact:getNormal()
		if not direct then
			nx, ny = -nx, -ny
		end
		local angle = math.atan2(ny, nx)
		
		if math.abs(angle - math.pi/2) < 0.5 then
			self.input:removeGround()
		end
	end
end