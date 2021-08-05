-- put user settings here
-- this module will be loaded after everything else when the application starts

local keymap = require "core.keymap"
local config = require "core.config"
local style = require "core.style"

-- light theme:
-- require "user.colors.fall"
style.blink_period = 1.2


-- key binding:
keymap.add { ["ctrl+q"] = "core:quit" }

for k,v in pairs(renderer) do print(k,v) end
for k,v in pairs(renderer.font) do print(k,v) end

core.clip_rect_stack[1]
renderer.font



function DocView:draw()
  DocView.super.draw(self)
  -- core.root_view:defer_draw(draw_suggestions_box, self)
  
end

core.canvas.draw_callbacks = {}

for i=1, 5 do
  core.canvas:draw_later(renderer.draw_rect, 1700, i*200, 100, 100, style.background2)
end


