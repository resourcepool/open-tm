---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local MIN_REFRESH_HEADING = 2
local WIDGET_START_X = 40
local WIDGET_START_Y = 20
local WIDGET_WIDTH = 133
local WIDGET_HEIGHT = 45
local HORIZON_WIDTH = 123
local HORIZON_HEIGHT = 39

local x0 = WIDGET_START_X + 5
local y0 = WIDGET_START_Y + 3
local centerX = x0 + HORIZON_WIDTH / 2
local centerY = WIDGET_START_Y + WIDGET_HEIGHT / 2
local x1 = x0 + HORIZON_WIDTH

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

local function init()
  accX = 0
  accY = 0
  accZ = 0
  pitchDeg = 0
  pitchRad = 0
  rollDeg = 0
  rollRad = 0
  horizonWidth = (WIDGET_WIDTH - 60) / 2
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

-- Draw degree value for sidebar
local function drawDegLine(cx, cy, offsetY, isTen, value)
  if isTen then
    lcd.drawLine(cx - 6, cy + offsetY, cx, cy + offsetY, SOLID, 0)
    if value < 0 then
      lcd.drawText(cx - 21, cy + offsetY - 2, value, INVERS + SMLSIZE)
    elseif value < 10 then
      lcd.drawText(cx - 11, cy + offsetY - 2, value, INVERS + SMLSIZE)
    else
      lcd.drawText(cx - 16, cy + offsetY - 2, value, INVERS + SMLSIZE)
    end
  else
    lcd.drawLine(cx - 4, cy + offsetY, cx, cy + offsetY, SOLID, 0)
  end
end

-- Draw the side bar
local function drawSideBar(cx, cy, ay0, up)
  -- number of pixels between lines
  local offset5 = 4
  local missingOffset, realOffset, inc, s
  -- compute remaining degrees before next multiple of 5
  if up then
    s = -1
    missingOffset = 5 - (ay0 % 5)
    realOffset = offset5 * missingOffset / 5
    inc = 5
  else
    s = 1
    missingOffset = ay0 % 5
    realOffset = offset5 * missingOffset / 5
    inc = -5
  end
  local n = ay0 - s * missingOffset
  local isTen = (n % 10) == 0
  for i = 0,3 do
    drawDegLine(cx, cy, s * (realOffset + i * offset5), isTen, n + i * inc)
    isTen = not isTen
  end
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
    horizonWidth = (HORIZON_WIDTH - 60) / 2
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
    local r1 = (HORIZON_WIDTH - 60) / 2
    local r2 = scale * HORIZON_HEIGHT / 4
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
  -- fill region in grey
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawFilledRectangle(x0, y0, HORIZON_WIDTH, HORIZON_HEIGHT, SOLID + GREY_DEFAULT)
  -- left wing
  lcd.drawLine(x0 + 40, centerY, x0 + 50, centerY, SOLID, 0)
  lcd.drawLine(x0 + 50, centerY, x0 + 50, centerY + 4, SOLID, 0)
  -- right wing
  lcd.drawLine(x1 - 40, centerY, x1 - 50, centerY, SOLID, 0)
  lcd.drawLine(x1 - 50, centerY, x1 - 50, centerY + 4, SOLID, 0)
  -- cockpit center
  lcd.drawLine(centerX - 3, centerY, centerX + 3, centerY, SOLID, 0)
  lcd.drawLine(centerX, centerY - 2, centerX, centerY + 2, SOLID, 0)
  -- contour
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw()
  -- up lines
  drawSideBar(x0 + HORIZON_WIDTH - 1, centerY, pitchDeg, true)
  -- down lines
  drawSideBar(x0 + HORIZON_WIDTH - 1, centerY, pitchDeg, false)
  -- horizon dashes
  lcd.drawLine(centerX - horizonWidth, centerY + horizonPitchDelta + horizonHeight, centerX + horizonWidth , centerY + horizonPitchDelta - horizonHeight, DOTTED, 0)
  if DEBUG then
    lcd.drawText(46, 40, "roll" .. math.floor(rollDeg), SMLSIZE)
    lcd.drawText(46, 48, "ptch" .. math.floor(pitchDeg), SMLSIZE)
  end
end

return { tag = "horizon", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
