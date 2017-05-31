---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local WIDGET_START_X = 107
local WIDGET_START_Y = 55
local WIDGET_WIDTH = 22
local WIDGET_HEIGHT = 10

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw(flightMode)
  -- draw flight mode
 lcd.drawText(WIDGET_START_X + 2, WIDGET_START_Y + 2, flightMode, SMLSIZE)
end


return { layout = layout, redraw = redraw }
