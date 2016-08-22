function entities.glue(x, y, angle, north)
	local entity = Entity.new()
	entity:addBehavior(behaviors.glue(x, y, angle, north))
	return entity
end