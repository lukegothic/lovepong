rng = love.math.newRandomGenerator( os.time() );
local M = {
  randomdouble = function (min, max)
    return rng:random() * (max - min) + min
  end
}
return M
