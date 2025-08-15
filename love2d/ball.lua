local Ball = {}
Ball.__index = Ball

function Ball:new(x, y, radius, vx, vy, color)
    local obj = {}
    setmetatable(obj, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.radius = radius or 0
    obj.vx = vx or 0
    obj.vy = vy or 0
    obj.color = color or YELLOW
    return obj
end

function Ball:update()
    self.x = self.x + self.vx;
    self.y = self.y + self.vy;

    if self.y + self.radius >= SCREEN_HEIGHT or self.y - self.radius <= 0 then
        self.vy = -self.vy
    end
    if self.x + self.radius >= SCREEN_WIDTH then
        enemy_score = enemy_score + 1
        self:reset()
    elseif self.x - self.radius <= 0 then
        player_score = player_score + 1
        self:reset()
    end
end

function Ball:reset()
    self.x = SCREEN_WIDTH / 2
    self.y = SCREEN_HEIGHT / 2

    local speed_choices = {1, -1}
    self.vx = self.vx * speed_choices[math.random(1, 2)];
    self.vy = self.vy * speed_choices[math.random(1, 2)];
end

function Ball:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Ball
