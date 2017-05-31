---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local WIDGET_START_X = 0
local WIDGET_START_BATTX = 5
local WIDGET_START_Y = 26
local WIDGET_START_BATTY = 36
local WIDGET_WIDTH = 34
local WIDGET_HEIGHT = 27
local BATT_WIDTH = 25
local BATT_HEIGHT = 15
-- Redraw battery value in volts
local function redrawVoltage(battPercent, battVolt)
  if battPercent< 10 then
    if battVolt < 10 then
      lcd.drawNumber(WIDGET_START_BATTX + 6, WIDGET_START_Y + 2, battVolt * 10, PREC1 + SMLSIZE)
      lcd.drawText(WIDGET_START_BATTX + 19, WIDGET_START_Y + 2, "V", SMLSIZE)
    else
      lcd.drawNumber(WIDGET_START_BATTX + 2, WIDGET_START_Y + 2, battVolt * 10, PREC1 + SMLSIZE)
      lcd.drawText(WIDGET_START_BATTX + 19, WIDGET_START_Y + 2, "V", SMLSIZE)
    end
  else
    if battVolt < 10 then
      lcd.drawNumber(WIDGET_START_BATTX + 6, WIDGET_START_Y + 2, battVolt * 10, PREC1 + SMLSIZE)
      lcd.drawText(WIDGET_START_BATTX + 19, WIDGET_START_Y + 2, "V", PREC1 + SMLSIZE)
    else
      lcd.drawNumber(WIDGET_START_BATTX + 2, WIDGET_START_Y + 2, battVolt * 10, PREC1 + SMLSIZE)
      lcd.drawText(WIDGET_START_BATTX + 19, WIDGET_START_Y + 2, "V", PREC1 + SMLSIZE)
    end
  end
end

-- Redraw battery value in percent
local function redrawPercent(battPercent)
  if battPercent<= 2 then
    lcd.drawText(WIDGET_START_BATTX, WIDGET_START_Y + 2, "Empty", SMLSIZE)
  elseif battPercent< 10 then
    lcd.drawNumber(WIDGET_START_BATTX + 7, WIDGET_START_Y + 2, battPercent, SMLSIZE)
    lcd.drawText(WIDGET_START_BATTX + 13, WIDGET_START_Y + 2, "%", SMLSIZE)
  elseif battPercent< 98 then
    lcd.drawNumber(WIDGET_START_BATTX + 2, WIDGET_START_Y + 2, battPercent, SMLSIZE)
    lcd.drawText(WIDGET_START_BATTX + 13, WIDGET_START_Y + 2, "%", SMLSIZE)
  else
    lcd.drawText(WIDGET_START_BATTX + 4, WIDGET_START_Y + 2, "Full", SMLSIZE)
  end
end

-- Redraw battery level container
local function redrawBattery(battPercent)
  if battPercent>= 20 then
    if battPercent< 26 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 1, WIDGET_START_BATTY + 2, 4, BATT_HEIGHT - 4)
    elseif battPercent< 40 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 1, WIDGET_START_BATTY + 2, 8, BATT_HEIGHT - 4)
    elseif battPercent< 60 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 1, WIDGET_START_BATTY + 2, 12, BATT_HEIGHT - 4)
    elseif battPercent< 80 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 1, WIDGET_START_BATTY + 2, 16, BATT_HEIGHT - 4)
    else
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 1, WIDGET_START_BATTY + 2, 20, BATT_HEIGHT - 4)
    end
  end
  for i = 0,4 do
      lcd.drawLine(WIDGET_START_BATTX + 1 + i * 4, WIDGET_START_BATTY + 1, WIDGET_START_BATTX + 1 + i * 4, WIDGET_START_BATTY + BATT_HEIGHT - 2, SOLID, ERASE)
  end
  if battPercent < 20 then
    lcd.drawText(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 5, "LOW!", SMLSIZE)
  end
end

-- Layout battery widget container
local function layout(battPercent)
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
  lcd.drawRectangle(WIDGET_START_BATTX, WIDGET_START_BATTY, BATT_WIDTH - 2, BATT_HEIGHT, GREY_DEFAULT)
  lcd.drawFilledRectangle(WIDGET_START_BATTX + BATT_WIDTH - 2, WIDGET_START_BATTY + BATT_HEIGHT / 2 - 3, 2, 6, FORCE)
end

-- Redraw battery widget
local function redraw(showBattVoltage, battPercent, battVolt)
  if showBattVoltage then
    redrawVoltage(battPercent, battVolt)
  else
    redrawPercent(battPercent)
  end
  redrawBattery(battPercent)
end


return { layout = layout, redraw = redraw }
