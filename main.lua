Paddle = {}
function Paddle:new(type, position)
  local newObj = { t = type, speed = 200, acceleration = 50, height = window.height / 10, width = 10, score = 0 }
  newObj.y = window.height / 2 - newObj.height / 2
  if (position == "LEFT") then
    newObj.x = 20
  elseif (position == "RIGHT") then
    newObj.x = window.width - 30
  end
  self.__index = self;
  return setmetatable(newObj, self)
end
local functions = require("functions")
function createBall()
  local angle = functions.randomdouble(3 * math.pi / 4, 5 * math.pi / 4)
  ball = { x = window.width / 2, y = window.height / 2, direction = { x = math.cos(angle) , y = math.sin(angle) }, speed = 100, acceleration = 10 }
end
function createPaddles()
  player1 = Paddle:new("PLAYER", "LEFT");
  player2 = Paddle:new("IA", "RIGHT");
end
function reset()
  createBall()
  createPaddles()
end
function love.load()
  window = {}
  window.width, window.height = love.graphics.getDimensions()
  love.graphics.setNewFont(12)
  love.graphics.setColor(255,255,255)
  love.graphics.setBackgroundColor(22,22,22)
  reset()
end
function love.update(dt)
  -- PLAYER
  if (love.keyboard.isDown("up")) then
    targety = player1.y - player1.speed * dt;
    if (targety < 0) then
      targety = 0
    end
    player1.y = targety;
  end
  if (love.keyboard.isDown("down")) then
    targety = player1.y + player1.speed * dt;
    if (targety > window.height - player1.height) then
      targety = window.height - player1.height
    end
    player1.y = targety;
  end
  -- IA: TODO
  -- BALL
  -- TODO: COLLISION W PADDLE
  local nextx, nexty = ball.x + ball.direction.x * dt * ball.speed, ball.y + ball.direction.y * dt * ball.speed;
  if (nextx < 0 or nextx > window.width) then
    if (nextx < 0) then
      player2.score = player2.score + 1
    else
      player1.score = player1.score + 1
    end
    createBall()
    --ball.direction.x = ball.direction.x * -1
  else
    ball.x = nextx;
  end
  if (nexty < 0 or nexty > window.height) then
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
  love.graphics.rectangle("fill", player1.x, player1.y, player1.width, player1.height )
  love.graphics.rectangle("fill", player2.x, player2.y, player2.width, player2.height )
  love.graphics.line( ball.x, ball.y, ball.x + ball.direction.x * 10000, ball.y + ball.direction.y * 10000 )
  love.graphics.print(player1.score, window.width / 2 - 20, 10)
  love.graphics.print(player2.score, window.width / 2 + 20, 10)
end
