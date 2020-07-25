size = {608, 316}

local backgroungImage = loadImage("yk42-loading.png")
local backgroundWidth, backgroundHeight = getTextureSize(backgroungImage)

local paxBars = {}
local paxRowCount = 20 -- количество пассажирских рядов

local pax_rows = {}
local ONE_PAX_WEIGHT = 75 -- вес одного пассажира, кг
local pax_weight = 0 -- вес всех пассажиров
local pax_count = 0 -- количество пассажиров
--local max_seats = 6 -- количество мест в ряду
local row_seats = {} -- данные о количестве мест в ряду


local ONE_PAX_BAG_WEIGHT = 12.5 -- вес багажа одного пассажира, кг
local cargo_weight = 0 -- вес груза

local fuel_weight = 0 -- вес топлива

local MEW = 31470 -- масса пустого самолета
local OEW = 32700 -- масса снаряженного самолета
local MTOW = 56500 -- максимальный взлетный вес



local buttonCursor = {
    -- finger cursor
    x = -8,
    y = -16,
    width = 20,
    height = 20,
    shape = loadImage("cursors.png", 280, 461, 20, 20),
    hideOSCursor = true
}


-- График пассажиров
for i = 1, paxRowCount do
    row_seats[i] = 6
end
local paxRows = payload_paxrows { 
    position = {177, 217, 404, 35},
    --seats = max_seats,
    row_count = paxRowCount,
    rows_data = {1,2,3,4,5,6,6,6,6,5,4,3,2,1},
    row_seats = row_seats
}

-- Окно с графиком груза (отсеки I, II, III)
local foreCargoRow = payload_paxrows {
    position = {177, 177, 198, 35},
    row_count = 3,
    rows_data = {10, 20, 30},
    row_seats = {136, 136, 136},
    color = {0, 1, 0}
}

-- Текстовые данные по загрузке
local payloadText = payload_text { 
    position = {11, 6, 324, 150},
    MEW = MEW,
    OEW = OEW,
    MTOW = MTOW,
}

components[#components + 1] = paxRows
components[#components + 1] = payloadText
components[#components + 1] = foreCargoRow

function recalcWeight()
    pax_rows = get(paxRows.rows_data)
    local old_pax_count = pax_count
    pax_count = 0
    for i = 1, paxRowCount do
        if not (pax_rows[i] == nil) then
            pax_count = pax_count + pax_rows[i]
        end
    end
    pax_weight = pax_count * ONE_PAX_WEIGHT
    local pax_diff = pax_count - old_pax_count 
    cargo_weight = cargo_weight + math.ceil(pax_diff * ONE_PAX_BAG_WEIGHT)
    if cargo_weight < 0 then
        cargo_weight = 0
    end
end

function updateTextBlock()
    payloadText.pax_weight = pax_weight
    payloadText.pax_count = pax_count
    payloadText.cargo_weight = cargo_weight
    payloadText.fuel_weight = fuel_weight
    payloadText.TOW = pax_weight + cargo_weight + fuel_weight + OEW
end


paxRows.update_cb = function()
    recalcWeight()
    updateTextBlock()
end


function textCargoCb(flag)
    if flag == 1 then
        cargo_weight = cargo_weight + 100
    else
        cargo_weight = cargo_weight - 100
    end
    recalcWeight()
    updateTextBlock()
end
function textFuelCb(flag)
    if flag == 1 then
        fuel_weight = fuel_weight + 100
    else
        fuel_weight = fuel_weight - 100
    end
    recalcWeight()
    updateTextBlock()
end

payloadText.pax_inc_cb = function() 
    pax_rows = get(paxRows.rows_data)
    for i = 1, paxRowCount do
        local cnt = pax_rows[i]
        if cnt == nil then
            cnt = 0
        end
        if cnt < max_seats then
            pax_rows[i] = cnt + 1
            break
        end
    end
    paxRows.rows_data = pax_rows
    recalcWeight()
    updateTextBlock()
end
payloadText.pax_dec_cb = function() 
    pax_rows = get(paxRows.rows_data)
    for i = paxRowCount, 1, -1  do
        local cnt = pax_rows[i]
        if cnt == nil then
            cnt = 0
        end
        if cnt > 0 then
            pax_rows[i] = cnt - 1
            break
        end
    end
    paxRows.rows_data = pax_rows
    recalcWeight()
    updateTextBlock()
end

payloadText.cargo_inc_cb = function() textCargoCb(1) end
payloadText.cargo_dec_cb = function() textCargoCb(0) end
payloadText.fuel_inc_cb = function() textFuelCb(1) end
payloadText.fuel_dec_cb = function() textFuelCb(0) end


paxRows.update_cb()

function draw()
    drawTexture(backgroungImage, 0, 0, backgroundWidth, backgroundHeight, {1,1,1,1})
    drawAll(components)
end

