---------------------------------
-- VARIABLES
---------------------------------
local timerNumber

local function init(radio)
  timerNumber = FLIGHT_TIMER
  layoutEngine = dofile("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/flighttime-" .. radio .. ".lua")
end

local function layout()
  layoutEngine.layout()
end

local function shouldRefresh(lastTimeSinceRedraw)
  if lastTimeSinceRedraw > 1000 then
    return true
  end
  return false
end

local function redraw()
    layoutEngine.redraw(timerNumber)
end

return { tag = "flighttime", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
