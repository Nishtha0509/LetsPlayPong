WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPPED = 200
BALL_SPEED = 90

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest','nearest')
    love.window.setTitle('Pong ')

    smallFont = love.graphics.newFont('04B_03__.TTF', 8)
    scoreFont = love.graphics.newFont('04B_03__.TTF', 32)

    player1score = 0
    player2score = 0

    -- intiate paddles
    paddle1 = Paddle(5, 20, 5, 25)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 25)

    -- initiate ball
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    gameState = 'init'

end

function love.update(dt)

    paddle1:update(dt)
    paddle2:update(dt)

    if ball:collides(paddle1) then
        -- deflect ball to right
        ball.dx = -ball.dx
    end

    if ball:collides(paddle2) then
        -- deflect ball to left
        ball.dx = -ball.dx
    end

    if ball.y <=0 then
        ball.dy = -ball.dy
        ball.y = 0
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
    end

    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPPED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPPED
    else
        paddle1.dy = 0
    end

    if love.keyboard.isDown('up') then
        paddle2.dy = -PADDLE_SPPED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPPED
    else
        paddle2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'init' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'init'
            ball:reset()
        end
    end 

end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
end

function love.draw()

    push:apply('start')

    love.graphics.clear(68/255, 80/255, 130/255, 255/255)

    love.graphics.setFont(smallFont)

    if gameState == 'init' then
        love.graphics.printf("Welcome Pong!", 0, 10, VIRTUAL_WIDTH , 'center')
    elseif gameState == 'play' then
        love.graphics.printf("Let's Play Pong!", 0, 10, VIRTUAL_WIDTH , 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- Render Ball
    ball:render()

    -- Render Paddles
    paddle1:render()
    paddle2:render()

    displayFPS()

    push:apply('end')

end 
