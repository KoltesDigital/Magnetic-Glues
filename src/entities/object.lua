function entities.object(filename, x, y)
	local entity = Entity.new()
	entity:addBehavior(behaviors.object(filename, x, y))
	return entity
end