local Ball = require("ball")
local Paddle = require("paddle")

local ball, player, enemy

local function check_collision(ball, paddle)
    local within_paddle_x = ball.x + ball.radius >= paddle.x and 
                            ball.x - ball.radius <= paddle.x + paddle.width
    local within_paddle_y = ball.y + ball.radius >= paddle.y and 
                            ball.y - ball.radius <= paddle.y + paddle.height
    return within_paddle_x and within_paddle_y
end

function love.load()
    SCREEN_WIDTH  = love.graphics.getWidth()
    SCREEN_HEIGHT = love.graphics.getHeight()
    PADDLE_WIDTH  = 15
    PADDLE_HEIGHT = 120
    PADDLE_GAP    = 5
    PADDLE_SPEED  = 1

    WHITE       = {1, 1, 1}
    GREEN       = {38/255, 185/255, 154/255}
    DARK_GREEN  = {20/255, 160/255, 133/255}
    LIGHT_GREEN = {129/255, 204/255, 184/255}
    YELLOW      = {243/255, 213/255, 91/255}

    enemy_score = 0
    player_score = 0

    ball = Ball:new(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 10, 1, 1)
    player = Paddle:new(
        SCREEN_WIDTH-PADDLE_WIDTH-PADDLE_GAP,
        SCREEN_HEIGHT/2-PADDLE_HEIGHT/2,
        PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_SPEED)
    enemy = Paddle:new(
        PADDLE_GAP, SCREEN_HEIGHT/2-PADDLE_HEIGHT/2, 
        PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_SPEED)

    love.graphics.setBackgroundColor(unpack(DARK_GREEN))
end

function love.update(dt)
    ball:update()
    player:update(false)
    enemy:update(true, ball.y)

    if check_collision(ball, player) or check_collision(ball, enemy) then
        ball.vx = -ball.vx
    end
end

function love.draw()
    love.graphics.setColor(unpack(LIGHT_GREEN))
    love.graphics.rectangle("fill", SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)

    love.graphics.setColor(unpack(WHITE))
    love.graphics.circle("line", SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 40)
    love.graphics.line(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)
    love.graphics.print(string.format("%i", enemy_score),
                        SCREEN_WIDTH/4-30, 20, 0, 10, 10)
    love.graphics.print(string.format("%i", player_score),
                        3*SCREEN_WIDTH/4-30, 20, 0, 10, 10)

    ball:draw()
    player:draw()
    enemy:draw()
end
