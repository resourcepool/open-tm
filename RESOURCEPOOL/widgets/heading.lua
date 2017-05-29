---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local MIN_REFRESH_HEADING = 2
local WIDGET_START_X = 40
local WIDGET_START_Y = 0
local WIDGET_WIDTH = 133
local WIDGET_HEIGHT = 20

local x0 = WIDGET_START_X + 5
local y0 = WIDGET_START_Y + 11
local width = WIDGET_WIDTH - 10
local center = x0 + width / 2
local x1 = x0 + width

---------------------------------
-- VARIABLES
---------------------------------
local heading

local function init()
  heading = 0
end

local function shouldRefresh(lastTimeSinceRedraw)
  -- Refresh Heading
  local newHeading = getValue("Hdg")
  if math.abs(heading - newHeading) > MIN_REFRESH_HEADING then
    heading = newHeading
    return true
  end
  return false
end

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawLine(x0, y0 + 2, x1, y0 + 2, SOLID, GREY_DEFAULT)
  lcd.drawPixmap(center - 2, y0, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/arrow-fwd.bmp")
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw()
  local offset = heading * width / 270
  -- angular projections
  local pn = (3 * width / 6 - offset) % (width * 8 / 6)
  local pe = (5 * width / 6 - offset) % (width * 8 / 6)
  local ps = (7 * width / 6 - offset) % (width * 8 / 6)
  local pw = (9 * width / 6 - offset) % (width * 8 / 6)

  -- text heights
  local upperLineY = y0 - 7
  local smallDivY = y0 + 3
  local largeDivY = y0 + 4

  if REAL_HEADING then
    -- assuming north is 0, then going counter-clockwise
    if pw <= width then
      lcd.drawText(x0 - 2 + pw, upperLineY, "W", SMLSIZE)
      lcd.drawLine(x0 + pw, y0, x0 + pw, smallDivY, SOLID, 0)
    end
    if pn <= width then
      lcd.drawText(x0 - 2 + pn, upperLineY, "N", SMLSIZE)
      lcd.drawLine(x0 + pn, y0, x0 + pn, largeDivY, SOLID, 0)
    end
    if pe <= width then
      lcd.drawText(x0 - 2 + pe, upperLineY, "E", SMLSIZE)
      lcd.drawLine(x0 + pe, y0, x0 + pe, smallDivY, SOLID, 0)
    end
    if ps <= width then
      lcd.drawText(x0 - 2 + ps, upperLineY, "S", SMLSIZE)
      lcd.drawLine(x0 + ps, y0, x0 + ps, largeDivY, SOLID, 0)
    end
  else
    -- assuming north is 0, then going counter-clockwise
    if pw <= width then
      lcd.drawPixmap(x0 - 2 + pw, upperLineY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/arrow-left.bmp")
      lcd.drawLine(x0 + pw, y0, x0 + pw, smallDivY, SOLID, 0)
    end
    if pn <= width then
      lcd.drawPixmap(x0 - 2 + pn, upperLineY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/arrow-fwd.bmp")
      lcd.drawLine(x0 + pn, y0, x0 + pn, largeDivY, SOLID, 0)
    end
    if pe <= width then
      lcd.drawPixmap(x0 - 2 + pe, upperLineY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/arrow-right.bmp")
      lcd.drawLine(x0 + pe, y0, x0 + pe, smallDivY, SOLID, 0)
    end
    if ps <= width then
      lcd.drawPixmap(x0 - 2 + ps, upperLineY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/arrow-bwd.bmp")
      lcd.drawLine(x0 + ps, y0, x0 + ps, largeDivY, SOLID, 0)
    end
  end
end

return { tag = "heading", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
