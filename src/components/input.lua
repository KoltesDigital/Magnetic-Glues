local Input = {}
Input._category = "inputs"
Input.__index = Input
setmetatable(Input, {__index = Component})

function components.input(filename, x, y)
	local self = Component.new()
	setmetatable(self, Input)
	
	self.speedX = 0
	self.ground = 0
	
	return self
end

function Input:keyPressed(key, unicode)
	if key == "a" then
		self.left = true
		self.speedX = -constants.playerSpeed
		self:emit("speedXChanged", self.speedX)
	elseif key == "d" then
		self.right = true
		self.speedX = constants.playerSpeed
		self:emit("speedXChanged", self.speedX)
	elseif key == "w" and self.ground > 0 then
		self:emit("speedYChanged", -constants.jumpSpeed)
	end
end

function Input:keyReleased(key, unicode)
	if key == "a" then
		self.left = false
		self.speedX = self.right and constants.playerSpeed or 0
		self:emit("speedXChanged", self.speedX)
	elseif key == "d" then
		self.right = false
		self.speedX = self.left and -constants.playerSpeed or 0
		self:emit("speedXChanged", self.speedX)
	end
end

function Input:mousePressed(x, y, button)
	self:emit("mousePressed", x, y, button)
end

function Input:update()
	if self.speedX then
		self:emit("speedXChanged", self.speedX)
	end
	
	self:emit("mousePositionChanged", love.mouse.getPosition())
end

function Input:addGround()
	self.ground = self.ground + 1
end

function Input:removeGround()
	self.ground = self.ground - 1
end

function Input:wall(right)
	if right then
		self.right = false
		self.speedX = self.left and -constants.playerSpeed or 0
		game:addTimeout(0.2, function()
			self.right = love.keyboard.isDown("d")
			self.speedX = self.right and constants.playerSpeed or self.left and -constants.playerSpeed or 0
			self:emit("speedXChanged", self.speedX)
		end)
	else
		self.left = false
		self.speedX = self.right and constants.playerSpeed or 0
		game:addTimeout(0.2, function()
			self.left = love.keyboard.isDown("a")
			self.speedX = self.left and -constants.playerSpeed or self.right and constants.playerSpeed or 0
			self:emit("speedXChanged", self.speedX)
		end)
	end
	self:emit("speedXChanged", self.speedX)
end
