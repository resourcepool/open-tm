---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local MIN_REFRESH_RSSI = 2
local WIDGET_START_X = 173
local WIDGET_START_Y = 0
local WIDGET_START_GAUGEX = WIDGET_START_X + 8
local WIDGET_START_GAUGEY = WIDGET_START_Y + 12
local WIDGET_WIDTH = 43
local WIDGET_HEIGHT = 44

local REFRESH_FREQUENCY_2S = 200
local SETTINGS = getGeneralSettings()
local _,LOW_RSSI = getRSSI()
local HIGH_RSSI = 90
---------------------------------
-- VARIABLES
---------------------------------
local rssi
local rssiPercent

local function init()
  rssi = 0
  rssiPercent = 0
end

local function shouldRefresh(lastTimeSinceRedraw)

  -- Redraw only every 2 seconds
  if lastTimeSinceRedraw < REFRESH_FREQUENCY_2S then
    return false
  end
  -- Refresh RSSI
  local newRssi = getRSSI()
  if math.abs(newRssi - rssi) <= 2 then
    return false
  end
  rssi = newRssi
  rssiPercent = math.max(0, (rssi - LOW_RSSI)) * 100 / (HIGH_RSSI - LOW_RSSI)

  return true
end

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw()
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


return { tag = "rssi", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
