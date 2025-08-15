local Paddle = {}
Paddle.__index = Paddle

function Paddle:new(x, y, width, height, v, color)
    local obj = {}
    setmetatable(obj, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.width = width or 0
    obj.height = height or 0
    obj.v = v or 0
    obj.color = color or WHITE
    return obj
end

function Paddle:update(is_ai, ball_y)
    if not is_ai then
        if love.keyboard.isDown("up") then
            self.y = self.y - self.v
        end
        if love.keyboard.isDown("down") then
            self.y = self.y + self.v
        end
    else
        if self.y + self.height/2 > ball_y then
            self.y = self.y - self.v
        end
        if self.y + self.height/2 < ball_y then
            self.y = self.y + self.v
        end
    end
    self:limit()
end

function Paddle:limit()
    if self.y < 0 then
        self.y = 0
    elseif self.y + self.height > SCREEN_HEIGHT then
        self.y = SCREEN_HEIGHT - self.height
    end
end

function Paddle:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Paddle
