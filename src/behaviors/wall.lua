local Wall = {}
Wall._name = "wall"
Wall.__index = Wall

function behaviors.wall(x, y, width, height)
	local self = {}
	setmetatable(self, Wall)
	
	self.body = components.body("rect", width/2, height/2, width, height)
	self.body:setPosition(x, y)
	
	return self
end

function Wall:setEntity(entity)
	self.entity = entity
	self.body:setData(entity)
	entity:addComponent(self.body)
end

function Wall:destroy()
	self.entity = nil
	self.body:destroy()
end