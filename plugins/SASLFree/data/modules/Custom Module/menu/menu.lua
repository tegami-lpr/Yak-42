-- Панель меню

size = {32, 32}
position = {0, 0, 32, 32}

components = {
        menu_icon {
        image = "weight_icon.png",
        command = "yak42/Toggle_Payload_Panel",
        panel =   { payload {} },
    },
}

function centering()
    local iCount = #components
    local iSpace = iCount - 1

    local menuHeight = iCount * 32 + iSpace * 3 -- высота иконки - 32px + 3px промежуток между ними
    size[1] = menuHeight
    
    local window_height = get(globalPropertyi("sim/graphics/view/window_height"))

    local y = window_height / 2 - menuHeight / 2

    position[2] = y
    position[4] = menuHeight

    y = 0
    for k, v in pairs(components) do
        v.position = {0, y, 32, 32}
        y = k * 32 + (k - 1) * 3
    end
end

centering()