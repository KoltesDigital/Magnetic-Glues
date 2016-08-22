local Background = {}
Background._name = "background"
Background.__index = Background

function behaviors.background(filename)
	local self = {}
	setmetatable(self, Background)
	
	self.image = components.image(filename, 0, 0, 0)
	
	return self
end

function Background:setEntity(entity)
	self.entity = entity
	entity:addComponent(self.image)
end

function Background:destroy()
	self.entity = nil
end