Component = {}
Component.__index = Component

function Component.new()
	local self = {}
	setmetatable(self, Component)
	
	self.listeners = {}
	
	return self
end

function Component:connect(signal, slot)
	if not self.listeners[signal] then
		self.listeners[signal] = {}
	end
	self.listeners[signal][slot] = true
end

function Component:emit(signal, ...)
	if self.listeners[signal] then
		for slot in pairs(self.listeners[signal]) do
			slot(...)
		end
	end
end