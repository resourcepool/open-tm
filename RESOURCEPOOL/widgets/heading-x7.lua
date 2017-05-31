---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local WIDGET_START_X = 33
local WIDGET_START_Y = 0
local WIDGET_WIDTH = 96
local WIDGET_HEIGHT = 17

---------------------------------
-- VARIABLES
---------------------------------
local x0 = WIDGET_START_X + 5
local y0 = WIDGET_START_Y + 10
local width = WIDGET_WIDTH - 10
local center = x0 + width / 2
local x1 = x0 + width

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawLine(x0, y0 + 2, x1, y0 + 2, SOLID, SOLID)
  lcd.drawText(center - 2, y0, "^")
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw(heading)
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
      lcd.drawText(x0 - 2 + pw, upperLineY + 1, "<")
      lcd.drawLine(x0 + pw, y0, x0 + pw, smallDivY, SOLID, 0)
    end
    if pn <= width then
      lcd.drawText(x0 - 2 + pn, upperLineY + 1, "^")
      lcd.drawLine(x0 + pn, y0, x0 + pn, largeDivY, SOLID, 0)
    end
    if pe <= width then
      lcd.drawText(x0 - 2 + pe, upperLineY, ">")
      lcd.drawLine(x0 + pe, y0, x0 + pe, smallDivY, SOLID, 0)
    end
    if ps <= width then
      lcd.drawText(x0 - 2 + ps, upperLineY - 1, "v")
      lcd.drawLine(x0 + ps, y0, x0 + ps, largeDivY, SOLID, 0)
    end
  end
end

return { layout = layout, redraw = redraw }
