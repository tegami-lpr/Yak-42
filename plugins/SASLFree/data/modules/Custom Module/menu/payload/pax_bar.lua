defineProperty("max", 0) -- максимальное количество пассажиров в ряду
defineProperty("actual", 0) -- текущее количество
defineProperty("color", {0, 0, 1})

local maxPax = get(max)
local drawHeight = size[2]
local barHeight =  math.floor((drawHeight - (maxPax - 1) * 2) / maxPax)
if barHeight < 0 then
    barHeight = 0
end

local actualPax = 0
if maxPax == nil then
    maxPax = 0
end
local barColor = get(color)

function update()
    actualPax = get(actual)
    if actualPax > maxPax then
        actualPax = maxPax
    end
end

function draw()
    local y = 0
    for i = 1, actualPax do 
        drawRectangle(0, y, size[1], barHeight, barColor)
        y = y + barHeight + 1
    end
end