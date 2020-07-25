size = { 2048, 2048 }

-- Нужно указывать эти значения для корректной работы курсора мыши
panelWidth2d = 1730
panelHeight2d = 1031

panel2d = true

addSearchPath(moduleDirectory.."/Custom Module/images/")

set(globalPropertys("sim/aircraft/view/acf_tailnum"), "RA42384")

-- компоненты
components = {
    menu {}
}
