---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local WIDGET_START_X = 0
local WIDGET_START_Y = 43
local WIDGET_WIDTH = 40
local WIDGET_HEIGHT = 24
---------------------------------
-- VARIABLES
---------------------------------
local timer

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawPixmap(WIDGET_START_X + 3, WIDGET_START_Y + 5, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/timer.bmp")
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw(timerNumber)
    -- Refresh timer
    timer = model.getTimer(timerNumber)
    lcd.drawTimer(WIDGET_START_X + 16, WIDGET_START_Y + 7, timer.value, 0)
end

return { layout = layout, redraw = redraw }
