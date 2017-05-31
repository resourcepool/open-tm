---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local WIDGET_START_X = 173
local WIDGET_START_Y = 0
local WIDGET_START_GAUGEX = WIDGET_START_X + 8
local WIDGET_START_GAUGEY = WIDGET_START_Y + 12
local WIDGET_WIDTH = 43
local WIDGET_HEIGHT = 44

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw(rssi, rssiPercent)
  lcd.drawNumber(WIDGET_START_GAUGEX + 2, WIDGET_START_Y + 3, rssi)
  lcd.drawText(WIDGET_START_GAUGEX + 13, WIDGET_START_Y + 3, "db")
  if rssiPercent == 0 then
    lcd.drawPixmap(WIDGET_START_GAUGEX, WIDGET_START_GAUGEY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/gauge-empty.bmp")
  elseif rssiPercent < 20 then
    lcd.drawPixmap(WIDGET_START_GAUGEX, WIDGET_START_GAUGEY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/gauge-1.bmp")
  elseif rssiPercent < 40 then
    lcd.drawPixmap(WIDGET_START_GAUGEX, WIDGET_START_GAUGEY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/gauge-2.bmp")
  elseif rssiPercent < 60 then
    lcd.drawPixmap(WIDGET_START_GAUGEX, WIDGET_START_GAUGEY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/gauge-3.bmp")
  elseif rssiPercent < 80 then
    lcd.drawPixmap(WIDGET_START_GAUGEX, WIDGET_START_GAUGEY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/gauge-4.bmp")
  else
    lcd.drawPixmap(WIDGET_START_GAUGEX, WIDGET_START_GAUGEY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/gauge-full.bmp")
  end
end


return { layout = layout, redraw = redraw }
