local Magnet = {}
Magnet._category = "inputs"
Magnet.__index = Magnet
setmetatable(Magnet, {__index = Component})

function components.magnet(angle, distance, dipole, power)
	local self = Component.new()
	setmetatable(self, Magnet)
	
	self.angle = angle
	self.distance = distance
	self.dipole = dipole
	self.power = power
	
	return self
end

function Magnet:setPosition(x, y, angle)
	self.x = x
	self.y = y
	self.originalAngle = angle
end

function Magnet:update()
	local north = game.entities.north
	local south = game.entities.south
	
	local px = self.x + math.cos(self.originalAngle + self.angle) * self.distance
	local py = self.y + math.sin(self.originalAngle + self.angle) * self.distance
	
	local fx, fy = 0, 0
	
	if north then
		local x, y = north.behaviors.glue.body:getPosition()
		local dx, dy = x - px, y - py
		local d2 = math.pow(dx, 2) + math.pow(dy, 2)
		if d2 < constants.minDistance2 then
			d2 = constants.minDistance2
		end
		local f = constants.gluePower * self.power / d2
		local angle = math.atan2(dy, dx)
		fx = fx + f * math.cos(angle)
		fy = fy + f * math.sin(angle)
	end 
	
	if south then
		local x, y = south.behaviors.glue.body:getPosition()
		local dx, dy = x - px, y - py
		local d2 = math.pow(dx, 2) + math.pow(dy, 2)
		if d2 < constants.minDistance2 then
			d2 = constants.minDistance2
		end
		local f = constants.gluePower * self.power / d2
		local angle = math.atan2(dy, dx)
		if self.dipole then
			angle = angle + math.pi
		end
		fx = fx + f * math.cos(angle)
		fy = fy + f * math.sin(angle)
	end 
	
	self:emit("forceApplied", fx, fy, self.x, self.y)
end