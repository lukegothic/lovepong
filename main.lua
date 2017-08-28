local functions = require("functions")
function reset()
  local angle = functions.randomdouble(3 * math.pi / 4, 5 * math.pi / 4)
  ball = { x = width / 2, y = height / 2, direction = { x = math.cos(angle) , y = math.sin(angle) }, speed = 100, acceleration = 10 }
end
function love.load()
  width, height = love.graphics.getDimensions()
  paddleH = height / 10;
  paddleSpeed = 200;
  player1 = { x = 20, y = height / 2 - paddleH / 2 }
  player2 = { x = width - 30, y = height / 2 - paddleH / 2 }
  love.graphics.setNewFont(12)
  love.graphics.setColor(255,255,255)
  love.graphics.setBackgroundColor(22,22,22)
  reset()
end
function love.update(dt)
  if (love.keyboard.isDown("up")) then
    targety = player1.y - paddleSpeed * dt;
    if (targety < 0) then
      targety = 0
    end
    player1.y = targety;
  end
  if (love.keyboard.isDown("down")) then
    targety = player1.y + paddleSpeed * dt;
    if (targety > height - paddleH) then
      targety = height - paddleH
    end
    player1.y = targety;
  end
  local nextx, nexty = ball.x + ball.direction.x * dt * ball.speed, ball.y + ball.direction.y * dt * ball.speed;
  if (nextx < 0 or nextx > width) then
    ball.direction.x = ball.direction.x * -1
  else
    ball.x = nextx;
  end
  if (nexty < 0 or nexty > height) then
    ball.direction.y = ball.direction.y * -1
  else
    ball.y = nexty;
  end
  ball.speed = ball.speed + ball.acceleration * dt;
end
function love.keypressed(key)
  if key == "r" then
    reset()
  end
end
function love.draw()
  love.graphics.circle( "fill", ball.x, ball.y, 6 )
  love.graphics.rectangle("fill", player1.x, player1.y, 10, paddleH )
  love.graphics.rectangle("fill", player2.x, player2.y, 10, paddleH )
  love.graphics.line( ball.x, ball.y, ball.x + ball.direction.x * 10000, ball.y + ball.direction.y * 10000 )
end
