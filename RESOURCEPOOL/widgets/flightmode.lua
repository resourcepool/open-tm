---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local WIDGET_START_X = 173
local WIDGET_START_Y = 43
local WIDGET_WIDTH = 40
local WIDGET_HEIGHT = 24

local REFRESH_FREQUENCY_2S = 200
local flightMode
---------------------------------
-- VARIABLES
---------------------------------
local flightMode

local function init()
  flightMode = 0
end

local function shouldRefresh(lastTimeSinceRedraw)

  -- Redraw only every 2 seconds
  if lastTimeSinceRedraw < REFRESH_FREQUENCY_2S then
    return false
  end
  -- Refresh Flight Mode
  local _, newFlightMode = getFlightMode()

  if newFlightMode == flightMode then
    return false
  end
  flightMode = newFlightMode
  return true
end

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw()
  -- draw flight mode
 lcd.drawText(WIDGET_START_X + 8, WIDGET_START_Y + 7, flightMode)
end


return { tag = "flightMode", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
