---------------------------------
-- GLOBAL VARIABLES
---------------------------------
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

local function redraw(horizonWidth, horizonHeight, horizonPitchDelta, pitchDeg, rollDeg)
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

return { layout = layout, redraw = redraw, width = 40, height = 40 }
