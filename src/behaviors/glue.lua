local Glue = {}
Glue._name = "glue"
Glue.__index = Glue

function behaviors.glue(x, y, angle, red)
	local self = {}
	setmetatable(self, Glue)
	
	self.onWall = false
	
	self.image = components.image("glue" .. (red and "Red" or "Blue") .. ".png", -16, -16, 2)
	
	self.body = components.body("circle", 0, 0, 1)
	self.body:setDynamic(0.1, 0.1)
	self.body:setBullet()
	self.body:setXSpeed(math.cos(angle) * constants.glueSpeed)
	self.body:setYSpeed(math.sin(angle) * constants.glueSpeed)
	
	self.body:connect("positionChanged", function(...)
		self.image:setPosition(...)
	end)
	
	self.body:setPosition(x, y)
	
	return self
end

function Glue:setEntity(entity)
	self.entity = entity
	self.body:setData(entity)
	entity:addComponent(self.image)
	entity:addComponent(self.body)
end

function Glue:destroy()
	self.entity = nil
	self.body:destroy()
end

function Glue:collisionAdded(other, contact, direct)
	if not self.onWall then
		if other.behaviors.wall then
			self.onWall = true
			
			local x, y = contact:getPosition()
			
			self.body:setPosition(x, y)
			self.body:setDynamic(0, 0)
		elseif self.entity then
			self.entity.toBeDestroyed = true
		end
	end
end