local Image = {}
Image._category = "images"
Image.__index = Image
setmetatable(Image, {__index = Component})

function components.image(filename, x, y, layer)
	local self = Component.new()
	setmetatable(self, Image)
	
	self.image = love.graphics.newImage("data/images/" .. filename)
	self.x = 0
	self.y = 0
	self.offsetX = x
	self.offsetY = y
	self.angle = 0
	self.layer = layer
	
	return self
end

function Image:setPosition(x, y, angle)
	self.x = x
	self.y = y
	if angle then
		self.angle = angle
		self:emit("angleChanged")
	end
	self:emit("positionChanged", x, y)
end

function Image:setAngle(angle)
	self.angle = angle
	self:emit("angleChanged")
end

function Image:getAngle()
	return self.angle
end

function Image:setFlipped(flipped)
	self.flipped = flipped
end

function Image:draw(layer)
	if self.layer == layer then
		love.graphics.draw(self.image, self.x, self.y, self.angle, self.flipped and -1 or 1, 1, -self.offsetX, -self.offsetY)
	end
end