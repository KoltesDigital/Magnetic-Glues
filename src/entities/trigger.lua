function entities.trigger(x, y, fn)
	local entity = Entity.new()
	entity:addBehavior(behaviors.object("trigger", x, y))
	game:registerTrigger(x, y, fn)
	return entity
end