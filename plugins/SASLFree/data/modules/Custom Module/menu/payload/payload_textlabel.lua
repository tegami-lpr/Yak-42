defineProperty("text", "")
defineProperty("color", {0,0,0})
defineProperty("background", nil)
defineProperty("font", nil)
defineProperty("font_size", {1,1})

local w = size[1]
local h = size[2]

local y = h/2 - get(font_size)/2
local bgColor = get(background)
local fontSize = get(font_size)

local labelText = get(text)
local textColor = get(color)

function update()
    labelText = get(text)
    textColor = get(color)
end

function draw()
    if not (bgColor == nil) then
        drawRectangle(0, 0, w, h, bgColor)
    end
    drawText(get(font), 0, y, labelText, fontSize, false, false, TEXT_ALIGN_LEFT, textColor)
end