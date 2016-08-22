local Body = {}
Body._category = "bodies"
Body.__index = Body
setmetatable(Body, {__index = Component})

function components.body(type, x, y, width, height, angle)
	local self = Component.new()
	setmetatable(self, Body)
	
	self.body = love.physics.newBody(world)
	if type == "rect" then
		self.shape = love.physics.newRectangleShape(self.body, x, y, width, height, angle or 0)
	elseif type == "circle" then
		self.shape = love.physics.newCircleShape(self.body, x, y, width)
	end
	
	return self
end

function Body:destroy()
	self.body:setPosition(-100, 0)
	self.body:destroy()
end

function Body:setData(data)
	self.shape:setData(data)
end

function Body:setDynamic(mass, inertia)
	if mass and inertia then
		if mass == 0 and inertia == 0 then
			self.body:putToSleep()
		end
		return self.body:setMass(0, 0, mass, inertia)
	end
	return self.body:setMassFromShapes()
end

function Body:setBullet()
	return self.body:setBullet(true)
end

function Body:setFixedRotation()
	return self.body:setFixedRotation(true)
end

function Body:noDamping()
	return self.body:setLinearDamping(0)
end

function Body:setPosition(x, y, angle)
	self.body:setPosition(x, y)
	if angle then
		self.body:setAngle(angle)
	end
	self:emit("positionChanged", x, y, angle or self.body:getAngle())
end

function Body:getPosition()
	return self.body:getPosition()
end

function Body:setXSpeed(speed)
	local x, y = self.body:getLinearVelocity()
	self.body:setLinearVelocity(speed, y)
	self.body:wakeUp()
end

function Body:setYSpeed(speed)
	local x, y = self.body:getLinearVelocity()
	self.body:setLinearVelocity(x, speed)
	self.body:wakeUp()
end

function Body:update()
	local x, y =  self.body:getPosition()
	self:emit("positionChanged", x, y, self.body:getAngle())
end

function Body:draw()
	local x, y = self.body:getPosition()
	love.graphics.setColor(72, 160, 14, 128) -- set the drawing color to green for the ground
	if self.shape.getPoints then
		love.graphics.polygon("fill", self.shape:getPoints()) -- draw a "filled in" polygon using the ground's coordinates
  	end
	love.graphics.circle("fill", x, y, 5) 
end