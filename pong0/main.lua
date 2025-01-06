WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

BOARD_SPEED = 200
BALL_SPEED = 50

push = require 'push'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest','nearest')

    smallFont = love.graphics.newFont('04B_03__.TTF', 8)
    scoreFont = love.graphics.newFont('04B_03__.TTF', 32)

    player1 = 0
    player2 = 0

    player1Y = 20
    player2Y = VIRTUAL_HEIGHT - 40

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    ballDX = math.random(2) == 1 and -BALL_SPEED or BALL_SPEED
    ballDY = math.random(-BALL_SPEED, BALL_SPEED)

    gameState = 'init'

end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y + -BOARD_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 25, player1Y + BOARD_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y + -BOARD_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 25, player2Y + BOARD_SPEED * dt) 
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
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
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and -BALL_SPEED or BALL_SPEED
            ballDY = math.random(-BALL_SPEED, BALL_SPEED)
        end
    end 

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
    love.graphics.print(player1, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- Ball
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    -- Boards
    love.graphics.rectangle('fill', 5, player1Y, 5, 25)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 25)

    push:apply('end')

end 