Entity = {}
Entity.__index = Entity

function Entity.new(options)
	local self = {}
	setmetatable(self, Entity)
	
	self.components = {}
	setmetatable(self.components, {__mode = "k"})
	
	self.behaviors = {}
	
	return self
end

function Entity:setGame(game)
	self.game = game
	for component in pairs(self.components) do
		game:addComponent(component)
	end
end

function Entity:destroy()
	for component in pairs(self.components) do
		game:removeComponent(component)
	end
	for _, behavior in pairs(self.behaviors) do
		if behavior.destroy then
			behavior:destroy()
		end
	end
	self.game = nil
end

function Entity:enable()
	self._enabled = true
	return self:trigger("enable")
end

function Entity:disable()
	self._enabled = false
	return self:trigger("disable")
end

function Entity:isEnabled()
	return self._enabled
end

function Entity:trigger(event, ...)
	for _, behavior in pairs(self.behaviors) do
		local handler = behavior[event]
		if handler then
			handler(behavior, ...)
		end
	end
end

function Entity:addBehavior(behavior)
	self.behaviors[behavior._name] = behavior
	if behavior.setEntity then
		behavior:setEntity(self)
	end
end

function Entity:addComponent(component)
	self.components[component] = true
end