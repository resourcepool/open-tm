---------------------------------
-- BEGIN OF CONFIGURATION
---------------------------------
-- This is your configuration. Modify it accordingly.
-- Tell us which radio you are using. It can be either x7 (Taranis QX7) or x9 (Taranis X9D / X9D+)
RADIO = "x9" -- Use this line if you are using Taranis X9D / X9D +
-- RADIO = "x7" -- Use this line if you are using Taranis QX7

-- This represents the timer of your flight time. First timer has index 0, second 1, etc...
-- You need to setup the timer yourself in your model. See docs for more details.
FLIGHT_TIMER = 0
-- Enable Real Heading if your drone has a compass. It will replace the arrows in the heading area by "North, West, South, East"
REAL_HEADING = true
-- Enable debug trace (will show debug data)
DEBUG = false
---------------------------------
-- END OF CONFIGURATION
---------------------------------

---------------------------------
-- GLOBAL VARIABLES
---------------------------------
-- Screen is 212x64 pixels
local REFRESH_FREQUENCY_30MS = 3
-- Always redraw each timeout seconds (3 seconds approx.)
local INVALIDATE_TIMEOUT = 300
---------------------------------
-- VARIABLES
---------------------------------
local lastTime
local lastRun

local widgets
local timerMatrix
local refreshMatrix
local firstDraw

-- Load widget from file
local function loadWidget(path)
  local w = loadScript(path)()
  w.init(RADIO)
  timerMatrix[w.tag] = 0
  refreshMatrix[w.tag] = false
  return w
end

-- Check whether widget should invalidate layout and redraw or not
local function checkRefreshFlag(widget)
  if  widget.shouldRefresh(lastTime - timerMatrix[widget.tag]) then
    timerMatrix[widget.tag] = lastTime
    refreshMatrix[widget.tag] = true
  end
end

-- Perform screen update of widget
local function refreshWidget(widget, force)
  if refreshMatrix[widget.tag] or force then
    widget.layout()
    widget.redraw()
    if DEBUG then
      lcd.drawText(46, 32, "drw" .. math.floor(lastTime / 10) % 90 + 10, SMLSIZE)
    end
    timerMatrix[widget.tag] = lastTime
    refreshMatrix[widget.tag] = false
  end
end

-- Init telemetry screen
local function init()
  firstDraw = true
  lastTime = 0
  lastRun = 0
  timerMatrix = {}
  refreshMatrix = {}
  widgets = {
    loadWidget("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/heading.lua"),
    loadWidget("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/flighttime.lua"),
    loadWidget("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/battery.lua"),
    loadWidget("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/horizon.lua"),
    loadWidget("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/rssi.lua"),
    loadWidget("/SCRIPTS/TELEMETRY/RESOURCEPOOL/widgets/flightmode.lua")
  }
end

local function background()
  local currentTime = getTime()
  -- Refresh at specific frequency
  if currentTime > lastTime + REFRESH_FREQUENCY_30MS then
    lastTime = currentTime
    for _, w in ipairs(widgets) do
      checkRefreshFlag(w)
    end
  end
  -- Force complete refresh at specific intervals
  if lastTime - lastRun > INVALIDATE_TIMEOUT then
    firstDraw = true
  end
end

local function run(event)
  if firstDraw then
    lcd.clear()
    for _, w in ipairs(widgets) do
      refreshWidget(w, true)
    end
    firstDraw = false
    lastRun = lastTime
    return
  end
  if DEBUG then
    lcd.drawText(46, 24, "cmp" .. math.floor(lastTime / 10) % 90 + 10, SMLSIZE)
  end
  for _, w in ipairs(widgets) do
    refreshWidget(w)
  end
end

return { init = init, background = background, run = run }
