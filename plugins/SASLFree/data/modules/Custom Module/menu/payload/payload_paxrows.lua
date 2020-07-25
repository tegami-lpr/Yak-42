defineProperty("row_count", 0) -- количество рядов
defineProperty("rows_data", {}) -- данные о количестве пассажиров в ряду
defineProperty("row_seats", {}) -- данные о максимальном количестве пассажиров в ряду
defineProperty("color", {0, 0, 1}) -- цвет отрисовки
defineProperty("update_cb", nil) -- callback при изменении количества пассажиров в ряду

local width = get(position)[3]
local height = get(position)[4]
local paxRowCount = get(row_count)
local paxBars = {}
local rowsData = get(rows_data)
local rowSeats = get(row_seats)

local buttonCursor = {
    -- finger cursor
    x = -8,
    y = -16,
    width = 20,
    height = 20,
    shape = loadImage("cursors.png", 280, 461, 20, 20),
    hideOSCursor = true
}


function fillPaxBar()
    local rowSpace = 2
    local barWidth = math.floor((width - (paxRowCount - 1) * rowSpace) / paxRowCount)
    local barColor = get(color)
    
    local x = 0
    for i = 1, paxRowCount do 
        paxBars[i] = pax_bar {position = {x, 0, barWidth, height}, size = {barWidth, height}, max = rowSeats[i], actual = rowsData[i], color = barColor}
        x = x + barWidth + rowSpace
    end
end

function fillPaxInteractive()
    for i = 1, paxRowCount do
        components[#components + 1] = interactive {
            cursor = buttonCursor,
            position = paxBars[i].position,
            onMouseDown = function()
                local actual = get(paxBars[i].actual)
                actual = actual + 1
                if actual > get(paxBars[i].max) then
                    actual = 0
                end
                set(paxBars[i].actual, actual)
                rowsData[i] = actual
                set(rows_data, rowsData)
                local updateCB = get(update_cb)
                if not (updateCB == nil) then
                    updateCB()
                end
            end
        }
    end
end

fillPaxBar()
fillPaxInteractive()

function update()
    rowsData = get(rows_data)
    for i = 1, paxRowCount do
        local actual = rowsData[i]
        if actual == nil then
            actual = 0
        end
        paxBars[i].actual = actual
    end
    updateAll(paxBars)
    updateAll(components)
end

function draw()
    drawAll(paxBars)
    drawAll(components)
end
