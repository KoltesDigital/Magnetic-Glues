function entities.wall(x, y, width, height)
	local entity = Entity.new()
	entity:addBehavior(behaviors.wall(x, y, width, height))
	return entity
end