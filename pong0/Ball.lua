Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = math.random(2) == 1 and -BALL_SPEED or BALL_SPEED
    self.dy = math.random(-BALL_SPEED, BALL_SPEED)
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    self.dx = math.random(2) == 1 and -BALL_SPEED or BALL_SPEED
    self.dy = math.random(-BALL_SPEED, BALL_SPEED)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:collides(entity)
    if self.x > entity.x + entity.width or self.x + self.width < entity.x then
        return false
    end

    if self.y > entity.y + entity.height or self.y + self.height < entity.y then
        return false
    end

    return true

end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end