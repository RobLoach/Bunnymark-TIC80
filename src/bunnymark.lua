-- title: Bunnymark in Lua
-- author: @RobLoach and Rabia Alhaffar
-- desc: Benchmarking tool to see how many bunnies can fly around the screen, using Lua.
-- input: gamepad
-- script: lua
-- version: 1.2.0

local screenWidth = 240
local screenHeight = 136
local toolbarHeight = 6
local t = 0

local Bunny
do
    local _class_0
    local _base_0 = {
        draw = function(self)
            return spr(self.sprite, self.x, self.y, 1, 1, 0, 0, 4, 4)
        end,
        update = function(self)
            self.x = self.x + self.speedX
            self.y = self.y + self.speedY
            if self.x + self.__class.width > screenWidth then
                self.x = screenWidth - self.__class.width
                self.speedX = self.speedX * -1
            end
            if self.x < 0 then
                self.x = 0
                self.speedX = self.speedX * -1
            end
            if self.y + self.__class.height > screenHeight then
                self.y = screenHeight - self.__class.height
                self.speedY = self.speedY * -1
            end
            if self.y < toolbarHeight then
                self.y = toolbarHeight
                self.speedY = self.speedY * -1
            end
        end
    }
    _base_0.__index = _base_0
    _class_0 = setmetatable({
        __init = function(self)
            self.x = math.random(0, screenWidth - self.__class.width)
            self.y = math.random(0, screenHeight - self.__class.height)
            self.speedX = math.random(-100, 100) / 60
            self.speedY = math.random(-100, 100) / 60
            self.sprite = 1
        end,
        __base = _base_0,
        __name = "Bunny"
    }, {
        __index = _base_0,
        __call = function(cls, ...)
            local _self_0 = setmetatable({}, _base_0)
            cls.__init(_self_0, ...)
            return _self_0
        end
    })
    _base_0.__class = _class_0
    local self = _class_0
    self.width = 26
    self.height = 32
    Bunny = _class_0
end

local FPS
do
    local _class_0
    local _base_0 = {
        getValue = function(self)
            if time() - self.lastTime <= 1000 then
                self.frames = self.frames + 1
            else
                self.value = self.frames
                self.frames = 0
                self.lastTime = time()
            end
            return self.value
        end
    }
    _base_0.__index = _base_0
    _class_0 = setmetatable({
        __init = function(self)
            self.value = 0
            self.frames = 0
            self.lastTime = 0
        end,
        __base = _base_0,
        __name = "FPS"
    }, {
        __index = _base_0,
        __call = function(cls, ...)
            local _self_0 = setmetatable({}, _base_0)
            cls.__init(_self_0, ...)
            return _self_0
        end
    })
    _base_0.__class = _class_0
    FPS = _class_0
end

local fps = FPS()
local bunnies = { }
table.insert(bunnies, Bunny())

TIC = function()
    if t == 0 then
        music(0)
    end
    if t == 6 * 64 * 2.375 then
        music(1)
    end

    t = t + 1
    if btn(0) then
        for i = 1, 5 do
            table.insert(bunnies, Bunny())
        end
    elseif btn(1) then
        for i = 1, 5 do
            table.remove(bunnies, 1)
        end
    end

    for i, item in pairs(bunnies) do
        item:update()
    end

    cls(15)
    for i, item in pairs(bunnies) do
        item:draw()
    end

    rect(0, 0, screenWidth, toolbarHeight, 0)
    print("Bunnies: " .. #bunnies, 1, 0, 11, false, 1, false)
    return print("FPS: " .. fps:getValue(), screenWidth / 2, 0, 11, false, 1, false)
end
