-- Иконка меню

size = {32, 32}

defineProperty("image")
defineProperty("command")
defineProperty("panel")

local command = findCommand(get(command))
local icon = loadImage(get(image))

local buttonCursor = {
    -- finger cursor
    x = -8,
    y = -16,
    width = 20,
    height = 20,
    shape = loadImage("cursors.png", 280, 461, 20, 20),
    hideOSCursor = true
}

cursor = buttonCursor

onMouseDown = function()
    commandOnce(command)
    return true
end

components[#components + 1] = get(panel)[1]

function draw()
    drawAll(components)
    if globalShowInteractiveAreas then
        drawFrame(0, 0, size[1], size[2], {0, 1, 0})
    end
    drawTexture(icon, 0, 0, size[1], size[2])
end