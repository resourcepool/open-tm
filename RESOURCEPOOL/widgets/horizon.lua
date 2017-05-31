---------------------------------
-- VARIABLES
---------------------------------

local accX
local accY
local accZ

local pitchRad
local pitchDeg

local rollDeg
local rollRad

local horizonPitchDelta
local horizonWidth
local horizonHeight

local layoutEngine

local function init(radio)
  layoutEngine = dofile("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/horizon-" .. radio .. ".lua")
  accX = 0
  accY = 0
  accZ = 0
  pitchDeg = 0
  pitchRad = 0
  rollDeg = 0
  rollRad = 0
  horizonWidth = (layoutEngine.width - 60) / 2
  horizonHeight = 0
  horizonPitchDelta = 0

end


-- Round Acc data when close to bounds
local function roundData(acc)
  if math.abs(acc) <= 0.02 then
    return 0
  end
  if acc > 0.98 then
    return 1
  end
  if acc < -0.98 then
    return -1
  end
  return acc
end

-- Check whether values changed significantly
local function notSignificantlyDifferent(x, y, z)
  return (math.abs(accX - x) < 0.1) and (math.abs(accY - y) < 0.1) and (math.abs(accZ - z) < 0.1)
end

local function shouldRefresh(lastTimeSinceRedraw)
  -- Refresh Accelerometer values
  local newAccX = roundData(getValue("AccX"))
  local newAccY = roundData(getValue("AccY"))
  local newAccZ = roundData(getValue("AccZ"))

  if notSignificantlyDifferent(newAccX, newAccY, newAccZ) then
    return false
  end

  accX = newAccX
  accY = newAccY
  accZ = newAccZ

  -- Compute horizon from accelerometer values
  if (accX == 0) and (accY == 0) and (accZ == 0) then
    -- When no value, set to 0
    pitchDeg = 0
    pitchRad = 0
    rollDeg = 0
    rollRad = 0
    horizonWidth = (layoutEngine.width - 60) / 2
    horizonHeight = 0
    horizonPitchDelta = 0
  else
    -- When value, compute Horizon
    local div = math.sqrt(accY * accY + accZ * accZ)
    pitchRad = math.atan2(accX, div)
    pitchDeg = math.floor(math.deg(pitchRad))
    rollRad = math.atan2(accY, accZ)
    rollDeg = math.floor(math.deg(rollRad))

    -- Size of horizon bar depends on Roll and Pitch
    local scale = 2 - math.min(1, math.abs(pitchDeg) / 45) -- Scale goes from 2 (when pitch < 45°) to 1 when pitch > 45°
    local r1 = (layoutEngine.width - 60) / 2
    local r2 = scale * layoutEngine.height / 4
    local sinRoll = math.sin(rollRad)
    local cosRoll = math.cos(rollRad)
    div = math.sqrt(r2*r2*cosRoll*cosRoll + r1*r1*sinRoll*sinRoll)
    horizonWidth = math.floor((r2 / scale) * r1 * cosRoll / div)
    horizonHeight = math.floor(r1 * r2 * sinRoll / div)
    horizonPitchDelta = math.floor(2 * r2 / scale * pitchDeg / 90)
  end
  return true
end

local function layout()
  layoutEngine.layout()
end

local function redraw()
  layoutEngine.redraw(horizonWidth, horizonHeight, horizonPitchDelta, pitchDeg, rollDeg)
end

return { tag = "horizon", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
