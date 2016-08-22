function entities.player(x, y)
	local entity = Entity.new()
	entity:addBehavior(behaviors.player(x, y))
	return entity
end