function entities.background(filename)
	local entity = Entity.new()
	entity:addBehavior(behaviors.background(filename))
	return entity
end