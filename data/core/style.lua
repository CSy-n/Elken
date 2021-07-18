local common = require "core.common"
local style = {}

style.padding = { x = common.round(14 * SCALE), y = common.round(7 * SCALE) }
style.divider_size = common.round(1 * SCALE)
style.scrollbar_size = common.round(4 * SCALE)
style.caret_width = common.round(2 * SCALE)
-- style.tab_width = common.round(170 * SCALE)
style.tab_width = common.round(120 * SCALE)
style.blink_period = 0.8


style.font = renderer.font.load(EXEDIR .. "/data/fonts/font.ttf", 14 * SCALE)
style.big_font = renderer.font.load(EXEDIR .. "/data/fonts/font.ttf", 34 * SCALE)
style.icon_font = renderer.font.load(EXEDIR .. "/data/fonts/icons.ttf", 16 * SCALE)
style.code_font = renderer.font.load(EXEDIR .. "/data/fonts/monospace.ttf", 13.5 * SCALE)

style.background = { common.color "#1F1F2B" }
style.background2 = { common.color "#181821" }
style.background3 = { common.color "#181821" }
style.text = { common.color "#8989ab" }
style.caret = { common.color "#8585FF" }
style.accent = { common.color "#ccccff" }
-- style.dim = { common.color "#42425c" }
style.dim = { common.color "#62625c" }
style.divider = { common.color "#15151C" }
style.selection = { common.color "#39394f" }
style.line_number = { common.color "#42425c" }
-- style.line_number2 = { common.color "#73739e" }
style.line_number2 = { common.color "#43735e" }
style.line_highlight = { common.color "#252533" }
-- style.scrollbar = { common.color "#323245" }
style.scrollbar = { common.color "#424245" }
-- style.scrollbar2 = { common.color "#3b3b52" }
style.scrollbar2 = { common.color "#4b4b52" }


style.syntax = {}
style.syntax["normal"] = { common.color "#F5F5F5" }
style.syntax["symbol"] = { common.color "#F5F5F5" }
style.syntax["comment"] = { common.color "#616C76" }
style.syntax["keyword"] = { common.color "#E58AC9" }
style.syntax["keyword2"] = { common.color "#F77483" }
style.syntax["number"] = { common.color "#FFA94D" }
style.syntax["literal"] = { common.color "#FFA94D" }
style.syntax["string"] = { common.color "#F8C34C" }
style.syntax["operator"] = { common.color "#93DDFA" }
style.syntax["function"] = { common.color "#93DDFA" }

-- ========================================================

-- style.background = { common.color "#2e2e32" }
-- style.background2 = { common.color "#252529" }
-- style.background3 = { common.color "#252529" }
-- style.text = { common.color "#97979c" }
-- style.caret = { common.color "#93DDFA" }
-- style.accent = { common.color "#e1e1e6" }
-- style.dim = { common.color "#525257" }
-- style.divider = { common.color "#202024" }
-- style.selection = { common.color "#48484f" }
-- style.line_number = { common.color "#525259" }
-- style.line_number2 = { common.color "#83838f" }
-- style.line_highlight = { common.color "#343438" }
-- style.scrollbar = { common.color "#414146" }
-- style.scrollbar2 = { common.color "#4b4b52" }

-- style.syntax = {}
-- style.syntax["normal"] = { common.color "#e1e1e6" }
-- style.syntax["symbol"] = { common.color "#e1e1e6" }
-- style.syntax["comment"] = { common.color "#676b6f" }
-- style.syntax["keyword"] = { common.color "#E58AC9" }
-- style.syntax["keyword2"] = { common.color "#F77483" }
-- style.syntax["number"] = { common.color "#FFA94D" }
-- style.syntax["literal"] = { common.color "#FFA94D" }
-- style.syntax["string"] = { common.color "#f7c95c" }
-- style.syntax["operator"] = { common.color "#93DDFA" }
-- style.syntax["function"] = { common.color "#93DDFA" }

return style
