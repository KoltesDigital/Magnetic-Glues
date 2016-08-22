local Object = {}
Object._name = "object"
Object.__index = Object

function behaviors.object(filename, x, y)
	local self = {}
	setmetatable(self, Object)
	
	self.name = filename
	
	local animation = love.filesystem.load("data/animations/" .. filename .. ".lua")()
	
	self.image = components.image(animation.image, animation.x, animation.y, 1)
	
	self.body = components.body("rect", 0, 0, animation.width, animation.height)
	if not animation.static then
		self.body:setDynamic(animation.mass, animation.inertia)
	end
	
	self.body:connect("positionChanged", function(...)
		self.image:setPosition(...)
	end)
	
	if animation.magnets then
		self.magnets = {}
		for _, magnet in pairs(animation.magnets) do
			local c = components.magnet(magnet.angle, magnet.distance, magnet.dipole, magnet.power)
			c:connect("forceApplied", function(...)
				self.body.body:applyForce(...)
			end)
			self.body:connect("positionChanged", function(...)
				c:setPosition(...)
			end)
		table.insert(self.magnets, c)
		end
	end
	
	self.body:setPosition(x, y)
	
	return self
end

function Object:setEntity(entity)
	self.entity = entity
	self.body:setData(entity)
	entity:addComponent(self.image)
	entity:addComponent(self.body)
	if self.magnets then
		for _, magnet in pairs(self.magnets) do
			entity:addComponent(magnet)
		end
	end
end

function Object:destroy()
	self.entity = nil
	self.body:destroy()
end

function Object:setYSpeed(speed)
	return self.body:setYSpeed(speed)
end