---------------------------------
-- GLOBAL VARIABLES
---------------------------------

local REFRESH_FREQUENCY_500MS = 50
local SETTINGS = getGeneralSettings()
local _,LOW_RSSI = getRSSI()
local HIGH_RSSI = 90
---------------------------------
-- VARIABLES
---------------------------------
local rssi
local rssiPercent

local layoutEngine

local function init(radio)
  rssi = 0
  rssiPercent = 0
  layoutEngine = loadScript("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/rssi-" .. radio .. ".lua")()
end

local function shouldRefresh(lastTimeSinceRedraw)

  -- Redraw only every 500 ms
  if lastTimeSinceRedraw < REFRESH_FREQUENCY_500MS then
    return false
  end
  -- Refresh RSSI
  local newRssi = getRSSI()
  if newRssi == rssi then
    return false
  end
  rssi = newRssi
  rssiPercent = math.max(0, (rssi - LOW_RSSI)) * 100 / (HIGH_RSSI - LOW_RSSI)
  return true
end

local function layout()
  layoutEngine.layout()
end

local function redraw()
  layoutEngine.redraw(rssi, rssiPercent)
end


return { tag = "rssi", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
