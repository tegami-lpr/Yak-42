-- Переменные для отображения значений загрузки
defineProperty("MEW", 0) -- Вес пустого самолета
defineProperty("OEW", 0) -- Вес подготовленного самолета
defineProperty("MTOW", 0) --Максимальный взлетный вес
defineProperty("pax_count", 0) -- количество пассажиров
defineProperty("pax_weight", 0) -- вес пассажиров
defineProperty("cargo_weight", 0) -- вес груза
defineProperty("fuel_weight", 0) -- вес топлива
defineProperty("TOW", 0) -- взлетный вес

-- Callbacks при нажатии на кнопки изменения веса
defineProperty("pax_inc_cb", nil)
defineProperty("pax_dec_cb", nil)

defineProperty("fuel_inc_cb", nil)
defineProperty("fuel_dec_cb", nil)

defineProperty("cargo_inc_cb", nil)
defineProperty("cargo_dec_cb", nil)


local font = loadFont("NotoSans-Condensed.ttf")

local clBlue = {0, 0, 1}
local clBlack = {0, 0, 0}
local clWhite = {1, 1, 1}
local clGreen = {0, 1, 0}
local clRed = {0, 1, 0}

local clLightGray = {0.54510, 0.60784, 0.61569}
local clDarkGray = {0.08235,  0.13333,  0.14118}

local labelTexts = {"Масса пустого:", "Снаряженный:", "Пассажиры:", "Груз:", "Топливо:", "Взлетная масса:", "Максимальный взлетный:"}

local constLabelWidth = 170
local varLabelWidth = 90

local leftCursor = {
    x = -8,
    y = -16,
    width = 20,
    height = 20,
    shape = loadImage("cursors.png", 275, 342, 20, 20),
    hideOSCursor = true
}

local rightCursor = {
    x = -8,
    y = -16,
    width = 20,
    height = 20,
    shape = loadImage("cursors.png", 344, 342, 20, 20),
    hideOSCursor = true
}



function createConstLabels()
    local lCount = #labelTexts
    local lHeight =  math.floor(size[2] / lCount)
    local y = math.floor(size[2] - lHeight)
    local background = nil
    local color = nil
    for k, v in pairs(labelTexts) do
        if background == nil then
            background = clLightGray
            color = clDarkGray
        else 
            background = nil   
            color = clWhite
        end

        components[#components + 1] = payload_textlabel {
            color = color,
            text = v,
            font_size = 14,
            font = font,
            background = background,
            position = {0, y, constLabelWidth, lHeight},
        }
        y = y - lHeight
    end
end

createConstLabels()

function createValueLables()
    local lCount = #components
    for i = 1, lCount do
        local clPos = get(components[i].position)
        local lHeight = clPos[4]
        local x = clPos[1] + clPos[3]
        local y = clPos[2]
        local color = clBlue
        local background = components[i].background
        local text = "placeholder"
        if i == 1 then 
            text = tostring(get(MEW)).." кг"
            color = clBlack
        elseif i == 2 then
            text = tostring(get(OEW)).." кг"
            color = clBlack
        elseif i == 7 then
            text = tostring(get(MTOW)).." кг"
            color = clBlack
        end

        components[#components + 1] = payload_textlabel {
            color = color,
            text = text,
            font_size = 14,
            font = font,
            background = background,
            position = {x, y, varLabelWidth, lHeight}
        }
    end
end

createValueLables()

function pax_cb(flagValue)
    local cb
    if flagValue == 1 then
        cb = get(pax_inc_cb)
    else
        cb = get(pax_dec_cb)
    end
    if not (cb == nil) then
        cb()
    end
end

function cargo_cb(flagValue)
    local cb
    if flagValue == 1 then
        cb = get(cargo_inc_cb)
    else
        cb = get(cargo_dec_cb)
    end
    if not (cb == nil) then
        cb()
    end
end

function fuel_cb(flagValue)
    local cb
    if flagValue == 1 then
        cb = get(fuel_inc_cb)
    else
        cb = get(fuel_dec_cb)
    end
    if not (cb == nil) then
        cb()
    end
end


function createClickableAreas()
    -- Управление пассажирами
    local position = get(components[3].position)
    local y = position[2]
    components[#components + 1] = interactive {
            position = {constLabelWidth - 15, y, 15, position[4]},
            cursor = leftCursor,
            onMouseDown = function()
                pax_cb(0)
            end
    }
    components[#components + 1] = interactive {
            position = {constLabelWidth + varLabelWidth - 15, y, 15, position[4]},
            cursor = rightCursor,
            onMouseDown = function()
                pax_cb(1)
            end
    }

    -- Управление весом груза
    local position = get(components[4].position)
    local y = position[2]
    components[#components + 1] = interactive {
            position = {constLabelWidth - 15, y, 15, position[4]},
            cursor = leftCursor,
            onMouseDown = function()
                cargo_cb(0)
            end
    }
    components[#components + 1] = interactive {
            position = {constLabelWidth + varLabelWidth - 15, y, 15, position[4]},
            cursor = rightCursor,
            onMouseDown = function()
                cargo_cb(1)
            end
    }

    -- Управление весом топлива
    position = get(components[5].position)
    y = position[2]
    components[#components + 1] = interactive {
            position = {constLabelWidth - 15, y, 15, position[4]},
            cursor = leftCursor,
            onMouseDown = function()
                fuel_cb(0)
            end
    }
    components[#components + 1] = interactive {
            position = {constLabelWidth + varLabelWidth - 15, y, 15, position[4]},
            cursor = rightCursor,
            onMouseDown = function()
                fuel_cb(1)
            end
    }    

end

createClickableAreas()


function update()
    -- пассажиры
    components[10].text = get(pax_weight) .. " кг (" .. get(pax_count) .. ")"
    -- вес груза
    components[11].text = get(cargo_weight) .. " кг"
    -- вес топлива
    components[12].text = get(fuel_weight) .. " кг"
    -- взлетный вес
    local total_weight = get(TOW)
    components[13].text = tostring(total_weight) .. " кг"
    if total_weight > get(MTOW) then
        components[13].color = clRed
    elseif total_weight == get(MTOW) then
        components[13].color = clYellow
    else
        components[13].color = clGreen
    end
    updateAll(components)
end