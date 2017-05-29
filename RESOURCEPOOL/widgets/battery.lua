---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local MIN_REFRESH_VBATT = 0.2
local WIDGET_START_X = 0
local WIDGET_START_BATTX = 10
local WIDGET_START_Y = 0
local WIDGET_START_BATTY = 13
local WIDGET_WIDTH = 40
local WIDGET_HEIGHT = 44

local REFRESH_FREQUENCY_2S = 200
local LIPO_CELL = 3.7
local LIPO_CELL_LOW = 3.5
local LIPO_CELL_MAX = 4.2
local LIPO_DELTA = LIPO_CELL_MAX - LIPO_CELL_LOW

---------------------------------
-- VARIABLES
---------------------------------
local batt
local battVolt
local showBattVoltage
local cellCount

local function init()
  batt = 0
  battVolt = 0
  showBattVoltage = false
  cellCount = 0
end

-- Redraw battery value in volts
local function redrawVoltage()
  if batt < 10 then
    if battVolt < 10 then
      lcd.drawNumber(WIDGET_START_BATTX + 3, WIDGET_START_Y + 3, battVolt * 10, PREC1)
      lcd.drawText(WIDGET_START_BATTX + 16, WIDGET_START_Y + 3, "V")
    else
      lcd.drawNumber(WIDGET_START_BATTX - 2, WIDGET_START_Y + 3, battVolt * 10, PREC1)
      lcd.drawText(WIDGET_START_BATTX + 16, WIDGET_START_Y + 3, "V")
    end
  else
    if battVolt < 10 then
      lcd.drawNumber(WIDGET_START_BATTX + 3, WIDGET_START_Y + 3, battVolt * 10, PREC1)
      lcd.drawText(WIDGET_START_BATTX + 16, WIDGET_START_Y + 3, "V", PREC1)
    else
      lcd.drawNumber(WIDGET_START_BATTX - 2, WIDGET_START_Y + 3, battVolt * 10, PREC1)
      lcd.drawText(WIDGET_START_BATTX + 16, WIDGET_START_Y + 3, "V", PREC1)
    end
  end
end

-- Redraw battery value in percent
local function redrawPercent()
  if batt <= 2 then
    lcd.drawText(WIDGET_START_BATTX - 3, WIDGET_START_Y + 3, "Empty")
  elseif batt < 10 then
    lcd.drawNumber(WIDGET_START_BATTX + 7, WIDGET_START_Y + 3, batt)
    lcd.drawText(WIDGET_START_BATTX + 13, WIDGET_START_Y + 3, "%")
  elseif batt < 98 then
    lcd.drawNumber(WIDGET_START_BATTX + 2, WIDGET_START_Y + 3, batt)
    lcd.drawText(WIDGET_START_BATTX + 13, WIDGET_START_Y + 3, "%")
  else
    lcd.drawText(WIDGET_START_BATTX, WIDGET_START_Y + 3, "Full")
  end
end

-- Redraw battery level
local function redrawBattery()
  if batt >= 20 then
    if batt < 26 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 21, 14, 4)
    elseif batt < 40 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 17, 14, 8)
    elseif batt < 60 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 13, 14, 12)
    elseif batt < 80 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 9, 14, 16)
    else
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 5, 14, 20)
    end
    for i = 0,4 do
        lcd.drawLine(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 5 + i * 4, WIDGET_START_BATTX + 16, WIDGET_START_BATTY + 5 + i * 4, SOLID, GREY_DEFAULT)
    end
  end
end

-- Detect Lipo Cell count
local function detectCellCount(vfas)
  local limit = LIPO_CELL_MAX
  if not vfas then
	return 0
  end
  if vfas < limit + 0.5 then
    return 1
  end
  if vfas < limit * 2 + 0.5 then
    return 2
  end
  if vfas < limit * 3 + 0.5 then
    return 3
  end
  if vfas < limit * 4 + 0.5 then
    return 4
  end
  if vfas < limit * 5 + 0.5 then
    return 5
  end
  if vfas < limit * 6 + 0.5 then
    return 6
  end
  return 0
end

local function shouldRefresh(lastTimeSinceRedraw)
  -- Redraw only every 2 seconds
  if lastTimeSinceRedraw < REFRESH_FREQUENCY_2S then
    return false
  end
  local newBattVolt = getValue("VFAS")
  -- Refresh Battery Level
  if showBattVoltage then
    showBattVoltage = false
  else
    showBattVoltage = true
  end
  battVolt = newBattVolt
  cellCount = detectCellCount(battVolt)
  batt = 0
  if cellCount > 0 then
    batt = math.max(0, (battVolt - LIPO_CELL_LOW * cellCount) * 100 / (LIPO_DELTA * cellCount))
  end
  return true
end

local function layout()
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  if batt < 20 then
    lcd.drawPixmap(WIDGET_START_BATTX, WIDGET_START_BATTY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/batt-empty.bmp")
  else
    lcd.drawPixmap(WIDGET_START_BATTX, WIDGET_START_BATTY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/batt.bmp")
  end
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
end

local function redraw()
  if showBattVoltage then
    redrawVoltage()
  else
    redrawPercent()
  end
  redrawBattery()
end


return { tag = "battery", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
