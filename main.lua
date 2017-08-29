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
function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
function paddleCollision()
  return checkCollision(player1.x, player1.y, player1.width, player1.height, ball.x, ball.y, ball.width, ball.height) or
         checkCollision(player2.x, player2.y, player2.width, player2.height, ball.x, ball.y, ball.width, ball.height)
end
function createBall()
  local angle = functions.randomdouble(3 * math.pi / 4, 5 * math.pi / 4)
  ball = { height = 10, width = 10, direction = { x = math.cos(angle), y = math.sin(angle) }, speed = 100, acceleration = 10 }
  ball.x, ball.y = window.width / 2 - ball.width / 2, window.height / 2 - ball.height / 2
end
function createPaddles()
  player1 = Paddle:new("PLAYER", "LEFT");
  player2 = Paddle:new("IA", "RIGHT");
end
function start()
  state = 1 -- 1: en curso, 2: fin
  love.graphics.setNewFont(12)
  love.graphics.setColor(255,255,255)
  createBall()
  createPaddles()
end
function menu()
  state = 0
  option = 1
  options = { "Start", "Exit" }
  print(#options)
end
function love.load()
  scorelimit = 5
  window = {}
  window.width, window.height = love.graphics.getDimensions()
  love.graphics.setBackgroundColor(22,22,22)
  menu()
end
function love.update(dt)
  if state == 1 then
    -- PLAYER
    local move = 0
    if (love.keyboard.isDown("up")) then
      move = -1
    elseif (love.keyboard.isDown("down")) then
      move = 1
    end
    if (move ~= 0) then
      player1.y = math.min(math.max(player1.y + player1.speed * dt * move, 0), window.height - player1.height)
    end
    -- IA, decide si va hacia arriba o hacia abajo y se mueve (se puede hacer mejor)
    player2.y = math.min(math.max(player2.y + (player2.speed * dt * (player2.y < ball.y and 1 or -1)), 0), window.height - player2.height)
    -- BALL
    -- REBOTE CON PALA
    if (paddleCollision()) then
      ball.direction.x = ball.direction.x * -1
    end
    -- REBOTE CON BOUNDS
    local nextx, nexty = ball.x + ball.direction.x * dt * ball.speed, ball.y + ball.direction.y * dt * ball.speed
    if (nextx < 0 or nextx > window.width - ball.width) then
      if (nextx < 0) then
        player2.score = player2.score + 1
      else
        player1.score = player1.score + 1
      end
      if (player1.score == scorelimit or player2.score == scorelimit) then
        state = 2
      else
        createBall()
      end
    else
      ball.x = nextx;
    end
    if (nexty < 0 or nexty > window.height - ball.height) then
      ball.direction.y = ball.direction.y * -1
    else
      ball.y = nexty;
    end
    ball.speed = ball.speed + ball.acceleration * dt;
  end
end
function love.keypressed(key)
  if state == 0 then
    if key == "up" then
      option = option - 1
      if option < 1 then
        option = #options
      end
    elseif key == "down" then
      option = option + 1
      if option > #options then
        option = 1
      end
    elseif key == "return" then
      if option == 1 then
        start()
      elseif option == 2 then
        love.event.quit()
      end
    elseif key == "escape" then
      love.event.quit()
    end
  elseif state == 1 then
    if key == "escape" then
      state = 0
    end
  elseif state == 2 then
    if key == "return" then
      start()
    elseif key == "esc" then
      state = 0
    end
  end
end
function love.draw()
  if state == 0 then
    for key, val in pairs(options) do
      if option == key then
        love.graphics.setNewFont(20)
        love.graphics.setColor(255,255,255)
      else
        love.graphics.setNewFont(12)
        love.graphics.setColor(160,160,160)
      end
      love.graphics.print( val, 100, key * 50 )
    end
  elseif state == 1 then
    love.graphics.rectangle( "fill", ball.x, ball.y, ball.width, ball.height, ball.width / 2, ball.height / 2 )
    love.graphics.rectangle( "fill", player1.x, player1.y, player1.width, player1.height )
    love.graphics.rectangle( "fill", player2.x, player2.y, player2.width, player2.height )
    --love.graphics.line( ball.x, ball.y, ball.x + ball.direction.x * 10000, ball.y + ball.direction.y * 10000 )
    love.graphics.print( player1.score, window.width / 2 - 20, 10 )
    love.graphics.print( player2.score, window.width / 2 + 20, 10 )
  elseif state == 2 then
    love.graphics.printf( player1.score > player2.score and "PLAYER" or "COMPUTER" .. " WINS", window.width / 2, window.height / 2, 100, "center" )
    -- TODO: que funcione el centrado
  elseif state == 3 then
    love.graphics.printf( "PAUSED", window.width / 2, window.height / 2, 100, "center" )
  end
end
function love.focus(f)
  if (f and state == 3) then
    state = 1
  elseif (f == false and state == 1) then
    state = 3
  end
end
