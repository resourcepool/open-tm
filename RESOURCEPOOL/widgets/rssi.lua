---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local MIN_REFRESH_RSSI = 2

local REFRESH_FREQUENCY_2S = 200
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
  layoutEngine = dofile("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/rssi-" .. radio .. ".lua")
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
  layoutEngine.layout()
end

local function redraw()
  layoutEngine.redraw(rssi, rssiPercent)
end


return { tag = "rssi", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
