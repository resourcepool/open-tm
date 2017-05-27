---------------------------------
-- BEGIN OF CONFIGURATION
---------------------------------
-- This is your configuration. Modify it accordingly.
-- This represents the timer of your flight time. First timer has index 0, second 1, etc...
-- You need to setup the timer yourself in your model. See docs for more details.
local FLIGHT_TIMER = 0
-- Enable Real Heading if your drone has a compass. It will replace the arrows in the heading area by "North, West, South, East"
local REAL_HEADING = true
---------------------------------
-- END OF CONFIGURATION
---------------------------------


---------------------------------
-- GLOBAL VARIABLES
---------------------------------
-- Screen is 212x64 pixels
local REFRESH_FREQUENCY_30MS = 30
local REFRESH_FREQUENCY_2S = 250
local SETTINGS = getGeneralSettings()
local _,LOW_RSSI = getRSSI()
local HIGH_RSSI = 90
local HORIZON_WIDTH = 120
local HORIZON_HEIGHT = 30
local LIPO_CELL = 3.7
local LIPO_CELL_LOW = 3.5
local LIPO_CELL_MAX = 4.2
local LIPO_DELTA = LIPO_CELL_MAX - LIPO_CELL_LOW
---------------------------------
-- VARIABLES
---------------------------------
local lastTime
local timer
local lastTimeBatt
local batt
local battVolt
local showBattVoltage
local rssi
local rssiPercent
local accX
local accY
local accZ
local heading
local flightMode

local pitchRad
local pitchDeg

local rollDeg
local rollRad

local horizonPitchDelta
local horizonWidth
local horizonHeight

local function init()
  lastTime = 0
  lastTimeBatt = 0
  showBattVoltage = false
end

-- Round Acc data when close to bounds
local function roundData(acc)
  if math.abs(acc) <= 0.02 then
    return 0
  end
  if acc > 0.98 then
    return 1
  end
  if acc < -0.98 then
    return -1
  end
  return acc
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

local function background()

  local currentTime = getTime()
  -- Refresh at specific frequency
  if currentTime > lastTime + REFRESH_FREQUENCY_30MS then
    lastTime = currentTime
    -- Refresh timer
    timer = model.getTimer(FLIGHT_TIMER)
    -- Refresh RSSI
    rssi = getRSSI()
    rssiPercent = math.max(0, (rssi - LOW_RSSI)) * 100 / (HIGH_RSSI - LOW_RSSI)
    -- Refresh Heading
    heading = getValue("Hdg")
    -- Refresh Battery Level
    battVolt = getValue("VFAS")
	if currentTime > lastTimeBatt + REFRESH_FREQUENCY_2S then
		lastTimeBatt = currentTime
		if showBattVoltage then
			showBattVoltage = false
		else
			showBattVoltage = true
		end
	end
    local cellCount = detectCellCount(battVolt)
    if cellCount == 0 then
      batt = 0
    else
      batt = math.max(0, (battVolt - LIPO_CELL_LOW * cellCount) * 100 / (LIPO_DELTA * cellCount))
    end
    -- Refresh Flight mode
    _, flightMode = getFlightMode()
    -- Refresh Accelerometer values
    accX = roundData(getValue("AccX"))
    accY = roundData(getValue("AccY"))
    accZ = roundData(getValue("AccZ"))
    -- Compute horizon from accelerometer values
    if accX == 0 and accY == 0 and accZ == 0 then
      -- When no value, set to 0
      pitchDeg = 0
      rollDeg = 0
      rollRad = 0
      deltaHorPitch = 0
      deltaHorRoll = 0
      horizonWidth = (HORIZON_WIDTH - 60) / 2
      horizonHeight = 0
      horizonPitchDelta = 0
    else
      -- When value, compute Horizon
      local div = math.sqrt(accY * accY + accZ * accZ)
      pitchRad = math.atan2(accX, div)
      pitchDeg = math.floor(math.deg(pitchRad))
      rollRad = math.atan2(accY, accZ)
      rollDeg = math.floor(math.deg(rollRad))
      -- Size of horizon bar depends on Roll and Pitch
      local scale = 2 - math.min(1, math.abs(pitchDeg) / 45) -- Scale goes from 2 (when pitch < 45°) to 1 when pitch > 45°
      local r1 = (HORIZON_WIDTH - 60) / 2
      local r2 = scale * HORIZON_HEIGHT / 4
      local sinRoll = math.sin(rollRad)
      local cosRoll = math.cos(rollRad)
      div = math.sqrt(r2*r2*cosRoll*cosRoll + r1*r1*sinRoll*sinRoll)
      horizonWidth = math.floor((r2 / scale) * r1 * cosRoll / div)
      horizonHeight = math.floor(r1 * r2 * sinRoll / div)
      horizonPitchDelta = math.floor(2 * r2 / scale * pitchDeg / 90)
    end
  end
end

local function drawRSSIWidget()
  lcd.drawNumber(182, 3, rssi)
  lcd.drawText(193, 3, "db")
  if rssiPercent == 0 then
    lcd.drawPixmap(180, 11, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/gauge-empty.bmp")
  elseif rssiPercent < 20 then
    lcd.drawPixmap(180, 11, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/gauge-1.bmp")
  elseif rssiPercent < 40 then
    lcd.drawPixmap(180, 11, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/gauge-2.bmp")
  elseif rssiPercent < 60 then
    lcd.drawPixmap(180, 11, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/gauge-3.bmp")
  elseif rssiPercent < 80 then
    lcd.drawPixmap(180, 11, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/gauge-4.bmp")
  else
    lcd.drawPixmap(180, 11, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/gauge-full.bmp")
  end
end

local function drawBatteryWidget()

  if showBattVoltage then
	if batt < 10 then
		if battVolt < 10 then
			lcd.drawNumber(13, 3, battVolt * 10, BLINK + PREC1)
			lcd.drawText(26, 3, "V", BLINK)
		else
			lcd.drawNumber(8, 3, battVolt * 10, BLINK + PREC1)
			lcd.drawText(26, 3, "V", BLINK)
		end
	else
		if battVolt < 10 then
			lcd.drawNumber(13, 3, battVolt * 10, PREC1)
			lcd.drawText(26, 3, "V", PREC1)
		else
			lcd.drawNumber(8, 3, battVolt * 10, PREC1)
			lcd.drawText(26, 3, "V", PREC1)
		end
	end
  else
	if batt < 10 then
		lcd.drawNumber(17, 3, batt, BLINK)
		lcd.drawText(23, 3, "%", BLINK)
	elseif batt < 98 then
		lcd.drawNumber(12, 3, batt)
		lcd.drawText(23, 3, "%")
	else
		lcd.drawText(10, 3, "Full")
	end
  end
  if batt < 20 then
    lcd.drawPixmap(10, 11, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/batt-empty.bmp")
  else
    lcd.drawPixmap(10, 11, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/batt.bmp")
    if batt < 26 then
      lcd.drawFilledRectangle(13, 32, 14, 4)
    elseif batt < 40 then
      lcd.drawFilledRectangle(13, 28, 14, 8)
    elseif batt < 60 then
      lcd.drawFilledRectangle(13, 24, 14, 12)
    elseif batt < 80 then
      lcd.drawFilledRectangle(13, 20, 14, 16)
    else
      lcd.drawFilledRectangle(13, 16, 14, 20)
    end
    for i = 0,4 do
        lcd.drawLine(13, 16 + i * 4, 26, 16 + i * 4, SOLID, GREY_DEFAULT)
    end
  end
end

local function drawFlightTime()
  lcd.drawPixmap(3, 49, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/timer.bmp")
  lcd.drawTimer(16, 51, timer.value, 0)
end

local function drawHeading()
  local x0 = 46
  local width = 120
  local center = x0 + width / 2
  local x1 = x0 + width
  lcd.drawLine(x0, 12, x1, 12, SOLID, GREY_DEFAULT)
  lcd.drawPixmap(center - 2, 10, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/arrow-fwd.bmp")
  local offset = heading * width / 270
  -- angular projections
  local pn = (3 * width / 6 - offset) % (width * 8 / 6)
  local pe = (5 * width / 6 - offset) % (width * 8 / 6)
  local ps = (7 * width / 6 - offset) % (width * 8 / 6)
  local pw = (9 * width / 6 - offset) % (width * 8 / 6)

  if REAL_HEADING then
    -- assuming north is 0, then going counter-clockwise
    if pw <= width then
      lcd.drawText(x0 - 2 + pw, 3, "W", SMLSIZE)
      lcd.drawLine(x0 + pw, 10, x0 + pw, 13, SOLID, 0)
    end
    if pn <= width then
      lcd.drawText(x0 - 2 + pn, 3, "N", SMLSIZE)
      lcd.drawLine(x0 + pn, 10, x0 + pn, 14, SOLID, 0)
    end
    if pe <= width then
      lcd.drawText(x0 - 2 + pe, 3, "E", SMLSIZE)
      lcd.drawLine(x0 + pe, 10, x0 + pe, 13, SOLID, 0)
    end
    if ps <= width then
      lcd.drawText(x0 - 2 + ps, 3, "S", SMLSIZE)
      lcd.drawLine(x0 + ps, 10, x0 + ps, 14, SOLID, 0)
    end
  else
    -- assuming north is 0, then going counter-clockwise
    if pw <= width then
      lcd.drawPixmap(x0 - 2 + pw, 3, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/arrow-left.bmp")
      lcd.drawLine(x0 + pw, 10, x0 + pw, 13, SOLID, 0)
    end
    if pn <= width then
      lcd.drawPixmap(x0 - 2 + pn, 3, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/arrow-fwd.bmp")
      lcd.drawLine(x0 + pn, 10, x0 + pn, 14, SOLID, 0)
    end
    if pe <= width then
      lcd.drawPixmap(x0 - 2 + pe, 3, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/arrow-right.bmp")
      lcd.drawLine(x0 + pe, 10, x0 + pe, 13, SOLID, 0)
    end
    if ps <= width then
      lcd.drawPixmap(x0 - 2 + ps, 3, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/arrow-bwd.bmp")
      lcd.drawLine(x0 + ps, 10, x0 + ps, 14, SOLID, 0)
    end
  end
end


local function drawDegLine(cx, cy, offsetY, isTen, value)
  if isTen then
    lcd.drawLine(cx - 6, cy + offsetY, cx, cy + offsetY, SOLID, 0)
    if value < 0 then
      lcd.drawText(cx - 21, cy + offsetY - 2, value, INVERS + SMLSIZE)
    elseif value < 10 then
      lcd.drawText(cx - 11, cy + offsetY - 2, value, INVERS + SMLSIZE)
    else
      lcd.drawText(cx - 16, cy + offsetY - 2, value, INVERS + SMLSIZE)
    end
  else
    lcd.drawLine(cx - 4, cy + offsetY, cx, cy + offsetY, SOLID, 0)
  end
end


local function drawDegLines(cx, cy, ay0, up)
  -- number of pixels between lines
  local offset5 = 4
  local missingOffset, realOffset, inc, s
  -- compute remaining degrees before next multiple of 5
  if up then
    s = -1
    missingOffset = 5 - (ay0 % 5)
    realOffset = offset5 * missingOffset / 5
    inc = 5
  else
    s = 1
    missingOffset = ay0 % 5
    realOffset = offset5 * missingOffset / 5
    inc = -5
  end
  local n = ay0 - s * missingOffset
  local isTen = (n % 10) == 0
  for i = 0,3 do
    drawDegLine(cx, cy, s * (realOffset + i * offset5), isTen, n + i * inc)
    isTen = not isTen
  end
end


local function drawHorizon()
  local x0 = 46
  local centerX = x0 + HORIZON_WIDTH / 2
  local centerY = 39
  local x1 = x0 + HORIZON_WIDTH
  lcd.drawFilledRectangle(x0, 18, HORIZON_WIDTH, 42, SOLID + GREY_DEFAULT)
  -- left wing
  lcd.drawLine(x0 + 40, centerY, x0 + 50, centerY, SOLID, 0)
  lcd.drawLine(x0 + 50, centerY, x0 + 50, centerY + 4, SOLID, 0)
  -- right wing
  lcd.drawLine(x1 - 40, centerY, x1 - 50, centerY, SOLID, 0)
  lcd.drawLine(x1 - 50, centerY, x1 - 50, centerY + 4, SOLID, 0)
  -- cockpit center
  lcd.drawLine(centerX - 3, centerY, centerX + 3, centerY, SOLID, 0)
  lcd.drawLine(centerX, centerY - 2, centerX, centerY + 2, SOLID, 0)
  -- horizon dashes
  lcd.drawLine(centerX - horizonWidth, centerY + horizonPitchDelta + horizonHeight, centerX + horizonWidth , centerY + horizonPitchDelta - horizonHeight, DOTTED, 0)
end



local function drawHorizonSideBar()
  local x0 = 46
  local centerX = x0 + HORIZON_WIDTH / 2
  local centerY = 39
  local x1 = x0 + HORIZON_WIDTH
  -- up lines
  drawDegLines(x0 + HORIZON_WIDTH - 1, centerY, pitchDeg, true)
  -- down lines
  drawDegLines(x0 + HORIZON_WIDTH - 1, centerY, pitchDeg, false)
end

local function drawFlightMode()
  -- draw flight mode
  lcd.drawText(181, 51, flightMode)
end

local function drawMonitor()
  lcd.drawLine(40, 1, 40, 64, SOLID, GREY_DEFAULT)
  lcd.drawLine(172, 1, 172, 64, SOLID, GREY_DEFAULT)
  lcd.drawLine(1, 44, 39, 44, SOLID, GREY_DEFAULT)
  lcd.drawLine(173, 44, 212, 44, SOLID, GREY_DEFAULT)
end

local function run(event)
  lcd.clear()
  -- Draw Flight Time
  drawFlightTime()
  -- Draw RSSI
  drawRSSIWidget()
  -- Draw Battery
  drawBatteryWidget()
  -- Draw Heading
  drawHeading()
  -- Draw Monitor
  drawMonitor()
  -- Draw Flight Mode
  drawFlightMode()
  -- Draw Horizon
  drawHorizon()
  -- Draw Horizon SideBars
  drawHorizonSideBar()
end

return { init = init, background = background, run = run }
