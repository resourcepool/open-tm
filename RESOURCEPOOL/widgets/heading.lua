---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local MIN_REFRESH_HEADING = 2

---------------------------------
-- VARIABLES
---------------------------------
local heading
local layoutEngine

local function init(radio)
  heading = 0
  layoutEngine = loadScript("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/heading-" .. radio .. ".lua")()
end

local function shouldRefresh(lastTimeSinceRedraw)
  -- Refresh Heading
  local newHeading = getValue("Hdg")
  if math.abs(heading - newHeading) > MIN_REFRESH_HEADING then
    heading = newHeading
    return true
  end
  return false
end

local function layout()
  layoutEngine.layout()
end

local function redraw()
  layoutEngine.redraw(heading)
end

return { tag = "heading", init = init, layout = layout, redraw = redraw, shouldRefresh = shouldRefresh }
