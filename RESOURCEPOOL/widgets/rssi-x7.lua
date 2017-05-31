---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local WIDGET_START_X = 0
local WIDGET_START_Y = 0
local WIDGET_START_GAUGEX = WIDGET_START_X + 8
local WIDGET_START_GAUGEY = WIDGET_START_Y + 12
local WIDGET_WIDTH = 34
local WIDGET_HEIGHT = 27
local OFFSET = (WIDGET_WIDTH - 4) / 5  -- one spacing between each bar + 2px offset on each side
local BAR_WIDTH = OFFSET - 1

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT)
end

local function redraw(rssi, rssiPercent)
  lcd.drawNumber(WIDGET_START_GAUGEX, WIDGET_START_Y + 3, rssi, SMLSIZE)
  lcd.drawText(WIDGET_START_GAUGEX + 10, WIDGET_START_Y + 3, "db", SMLSIZE)
  for i = 0,4 do
      if (rssiPercent >= 20 * i and rssiPercent > 10) then
        lcd.drawFilledRectangle(WIDGET_START_X + 2 + OFFSET * i, WIDGET_START_Y + 10 + 15 * (4 - i) / 5, BAR_WIDTH, 15 * (i + 1) / 5)
      else
        lcd.drawRectangle(WIDGET_START_X + 2 + OFFSET * i, WIDGET_START_Y + 10 + 15 * (4 - i) / 5, BAR_WIDTH, 15 * (i + 1) / 5)
      end
  end
  if rssiPercent < 20 then
    lcd.drawText(WIDGET_START_X + WIDGET_WIDTH / 2 + 2, WIDGET_START_Y + 19, "low", SMLSIZE + INVERS)
  end
end

return { layout = layout, redraw = redraw }
