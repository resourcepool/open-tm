---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local MIN_REFRESH_VBATT = 0.2

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
local layoutEngine

local function init(radio)
  batt = 0
  battVolt = 0
  showBattVoltage = false
  cellCount = 0
  layoutEngine = loadScript("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/battery-" .. radio .. ".lua")()
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
  layoutEngine.layout(batt)
end

local function redraw()
  layoutEngine.redraw(showBattVoltage, batt, battVolt)
end

return { tag = "battery", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
