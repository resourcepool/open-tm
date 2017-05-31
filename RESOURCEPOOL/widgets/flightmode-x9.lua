---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local WIDGET_START_X = 173
local WIDGET_START_Y = 43
local WIDGET_WIDTH = 40
local WIDGET_HEIGHT = 24

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw(flightMode)
  -- draw flight mode
 lcd.drawText(WIDGET_START_X + 8, WIDGET_START_Y + 7, flightMode)
end


return { layout = layout, redraw = redraw }
