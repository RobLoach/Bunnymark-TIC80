-- title: Bunnymark in Lua
-- author: Rabia Alhaffar
-- desc: Benchmarking tool to see how many bunnies can fly around the screen, using Lua.
-- input: gamepad
-- script: lua
-- version: 1.1.0

screenWidth = 240
screenHeight = 136
toolbarHeight = 6
t = 0

function randomFloat(lower, greater)
    return (math.random() * (greater - lower)) + lower;
end

Bunny = {width=0,height=0,x=0,y=0,speedX=0,speedY=0,sprite=0}

function Bunny:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
	self.width = 26
	self.height = 32
	self.x = math.random(0, screenWidth - self.width)
	self.y = math.random(0, screenHeight - self.height)
	self.speedX = randomFloat(-100, 100) / 60
    self.speedY = randomFloat(-100, 100) / 60
	self.sprite = 1
	return o
end

function Bunny:draw()
  spr(self.sprite, self.x, self.y, 1, 1, 0, 0, 4, 4)
end

function Bunny:update()
    self.x = self.x + self.speedX
    self.y = self.x + self.speedY

    if (self.x + self.width > screenWidth) then
        self.x = screenWidth - self.width
        self.speedX = self.speedX * -1
    end
    if (self.x < 0) then
        self.x = 0
        self.speedX = self.speedX * -1
    end
    if (self.y + self.height > screenHeight) then
        self.y = screenHeight - self.height
        self.speedY = self.speedY * -1
    end
    if (self.y < toolbarHeight) then
        self.y = toolbarHeight
        self.speedY = self.speedY * -1
    end
end

FPS = {}

function FPS:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.value = 0
    self.frames = 0
    self.lastTime = 0
    return FPS
end

function FPS:getValue()
    if (time() - self.lastTime <= 1000) then
        self.frames = self.frames + 1
    else
        self.value = self.frames
        self.frames = 0
        self.lastTime = time()
    end
    return self.value
end

fps = FPS:new()
bunnies = {}
table.insert(bunnies, Bunny:new())

function TIC()
    -- music
    if t == 0 then
        music(0)
    end
    if t == 6*64*2.375 then
        music(1)
    end
    t = t + 1

    -- Input
    if btn(0) then
        for i = 1, 5 do
            table.insert(bunnies, Bunny:new())
        end
    end
    if btn(1) then
        for i = 1, 5 do
			if next(bunnies) ~= nil then
                table.remove(bunnies, i0)
            end
        end
    end

    -- Update
    for i, item in pairs(bunnies) do
        item:update()
    end

    -- Draw
    cls(15)
    for i, item in pairs(bunnies) do
        item:draw()
    end

    rect(0, 0, screenWidth, toolbarHeight, 0)
    print("Bunnies: " .. #bunnies, 1, 0, 11, false, 1, false)
    print("FPS: " .. fps:getValue(), screenWidth / 2, 0, 11, false, 1, false)
end