WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPPED = 200
BALL_SPEED = 100

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
    victoryFont = love.graphics.newFont('04B_03__.TTF', 24)

    player1score = 0
    player2score = 0
    servingPlayer = math.random(2) == 1 and 1 or 2
    winningPlayer = 0

    -- intiate paddles
    paddle1 = Paddle(5, 20, 5, 25)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 25)

    -- initiate ball
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    if servingPlayer == 1 then
        ball.dx = BALL_SPEED
    else
        ball.dx = -BALL_SPEED
    end

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

    -- update the scores and reset
    if ball.x <= 0 then
        player2score = player2score + 1
        ball:reset()
        servingPlayer = 1
        ball.dx = BALL_SPEED

        if player2score >= 2 then
            gameState = 'victory'
            winningPlayer = 2
        else
            gameState = 'serve'
        end

    elseif ball.x >= VIRTUAL_WIDTH - 4 then
        player1score = player1score + 1
        ball:reset()
        ball.dx = -BALL_SPEED
        servingPlayer = 2
        
        if player1score >= 2 then
            gameState = 'victory'
            winningPlayer = 1
        else
            gameState = 'serve'
        end

    end

    -- handle collisions
    if ball:collides(paddle1) then
        -- deflect ball to right and increase the speed slightly 
        ball.dx = -ball.dx * 1.03
        ball.x = paddle1.x + 5

        -- randomise dy just for fun!
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10,150)
        end
    end

    if ball:collides(paddle2) then
        -- deflect ball to left and increase the speed slightly 
        ball.dx = -ball.dx * 1.03
        ball.x = paddle2.x - 5

        -- randomise dy just for fun!
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10,150)
        end
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
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'victory' then
            gameState = 'init'
            player1score = 0
            player2score = 0
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
        love.graphics.printf("Welcome to Pong!", 0, 10, VIRTUAL_WIDTH , 'center')
        love.graphics.printf("Press Enter to Start!", 0, 20, VIRTUAL_WIDTH , 'center')
    elseif gameState == 'serve' then
        love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s Turn!", 0, 10, VIRTUAL_WIDTH , 'center')
        love.graphics.printf("Press Enter to Serve!", 0, 20, VIRTUAL_WIDTH , 'center')
    elseif gameState == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " Wins!!", 0, 10, VIRTUAL_WIDTH , 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter to Start Again!", 0, 40, VIRTUAL_WIDTH , 'center')
    end 

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2score, VIRTUAL_WIDTH / 2 + 35, VIRTUAL_HEIGHT / 3)

    -- Render Ball
    ball:render()

    -- Render Paddles
    paddle1:render()
    paddle2:render()

    displayFPS()

    push:apply('end')

end 
