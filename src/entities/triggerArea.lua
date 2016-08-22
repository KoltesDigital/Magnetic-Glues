function entities.triggerArea(x, fn)
	local entity = Entity.new()
	game:registerTriggerArea(x, fn)
	return entity
end