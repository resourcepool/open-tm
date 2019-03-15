---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local WIDGET_START_X = 0
local WIDGET_START_Y = 51
local WIDGET_WIDTH = 34
local WIDGET_HEIGHT = 13
---------------------------------
-- VARIABLES
---------------------------------
local timer

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawText(WIDGET_START_X + 1, WIDGET_START_Y, "o", MIDSIZE)
  lcd.drawLine(WIDGET_START_X + 4, WIDGET_START_Y + 7, WIDGET_START_X + 5, WIDGET_START_Y + 7, SOLID, FORCE)
  lcd.drawLine(WIDGET_START_X + 4, WIDGET_START_Y + 7, WIDGET_START_X + 4, WIDGET_START_Y + 4, SOLID, FORCE)
  --lcd.drawPixmap(WIDGET_START_X + 3, WIDGET_START_Y + 5, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/timer.bmp")
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw(timerNumber)
    -- Refresh timer
    timer = model.getTimer(timerNumber)
    lcd.drawTimer(WIDGET_START_X + 10, WIDGET_START_Y + 4, timer.value, 0)
end

return { layout = layout, redraw = redraw }
