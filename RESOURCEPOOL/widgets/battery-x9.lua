---------------------------------
-- GLOBAL VARIABLES
---------------------------------
local WIDGET_START_X = 0
local WIDGET_START_BATTX = 10
local WIDGET_START_Y = 0
local WIDGET_START_BATTY = 13
local WIDGET_WIDTH = 40
local WIDGET_HEIGHT = 44

-- Redraw battery value in volts
local function redrawVoltage(battPercent, battVolt)
  if battPercent< 10 then
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
local function redrawPercent(battPercent)
  if battPercent<= 2 then
    lcd.drawText(WIDGET_START_BATTX - 3, WIDGET_START_Y + 3, "Empty")
  elseif battPercent< 10 then
    lcd.drawNumber(WIDGET_START_BATTX + 7, WIDGET_START_Y + 3, batt)
    lcd.drawText(WIDGET_START_BATTX + 13, WIDGET_START_Y + 3, "%")
  elseif battPercent< 98 then
    lcd.drawNumber(WIDGET_START_BATTX + 2, WIDGET_START_Y + 3, batt)
    lcd.drawText(WIDGET_START_BATTX + 13, WIDGET_START_Y + 3, "%")
  else
    lcd.drawText(WIDGET_START_BATTX, WIDGET_START_Y + 3, "Full")
  end
end

-- Redraw battery level container
local function redrawBattery(battPercent)
  if battPercent>= 20 then
    if battPercent< 26 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 21, 14, 4)
    elseif battPercent< 40 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 17, 14, 8)
    elseif battPercent< 60 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 13, 14, 12)
    elseif battPercent< 80 then
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 9, 14, 16)
    else
      lcd.drawFilledRectangle(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 5, 14, 20)
    end
    for i = 0,4 do
        lcd.drawLine(WIDGET_START_BATTX + 3, WIDGET_START_BATTY + 5 + i * 4, WIDGET_START_BATTX + 16, WIDGET_START_BATTY + 5 + i * 4, SOLID, GREY_DEFAULT)
    end
  end
end

-- Layout battery widget container
local function layout(battPercent)
  lcd.drawFilledRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, ERASE)
  if battPercent < 20 then
    lcd.drawPixmap(WIDGET_START_BATTX, WIDGET_START_BATTY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/batt-empty.bmp")
  else
    lcd.drawPixmap(WIDGET_START_BATTX, WIDGET_START_BATTY, "/SCRIPTS/TELEMETRY/RESOURCEPOOL/images/batt.bmp")
  end
  lcd.drawRectangle(WIDGET_START_X, WIDGET_START_Y, WIDGET_WIDTH, WIDGET_HEIGHT, GREY_DEFAULT)
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
