---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local REFRESH_FREQUENCY_2S = 200
local flightMode
---------------------------------
-- VARIABLES
---------------------------------
local flightMode
local layoutEngine

local function init(radio)
  flightMode = 0
  layoutEngine = dofile("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/flightmode-" .. radio .. ".lua")
end

local function shouldRefresh(lastTimeSinceRedraw)

  -- Redraw only every 2 seconds
  if lastTimeSinceRedraw < REFRESH_FREQUENCY_2S then
    return false
  end
  -- Refresh Flight Mode
  local _, newFlightMode = getFlightMode()

  if newFlightMode == flightMode then
    return false
  end
  flightMode = newFlightMode
  return true
end

local function layout()
  layoutEngine.layout()
end

local function redraw()
  layoutEngine.redraw(flightMode)
end


return { tag = "flightMode", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
