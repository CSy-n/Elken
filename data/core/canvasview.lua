local core = require "core"
local style = require "core.style"
local View = require "core.view"

 -- Ax: <Entry>
 -- Based on: LogView

local CanvasView = View:extend()


function CanvasView:new()
  CanvasView.super.new(self)
--   self.last_item = core.log_items[#core.log_items]
  self.scrollable = true
  self.yoffset = 20
  last_time = 1
end


function CanvasView:get_name()
  return "Canvas"
end


function CanvasView:update()
  local item = core.log_items[#core.log_items]
  if self.last_item ~= item then
    self.last_item = item
    self.scroll.to.y = 0
    self.yoffset = -(style.font:get_height() + style.padding.y)
  end

  local time = system.get_time()
  elapsed_time = time - last_time
  last_time = time

  -- Update new status
--   renderer.draw_rect(500, 500, 200, 200, style.background1)
--   renderer.draw_rect(100 + elapsed_time * 100000, 100, 300, 300, style.line_highlight)
--   print(elapsed_time)

  self:move_towards("yoffset", 0)
  CanvasView.super.update(self)
end


local function draw_text_multiline(font, text, x, y, color)
  local th = font:get_height()
  local resx, resy = x, y
  for line in text:gmatch("[^\n]+") do
    resy = y
    resx = renderer.draw_text(style.font, line, x, y, color)
    y = y + th
  end
  return resx, resy
end

-- Ax: <Entry>: Drawing via Canvas
function CanvasView:draw()
  self:draw_background(style.background)

  -- Display Rectangle: [X-Coord, Y-Coord, Width, Height, Color]
  -- renderer.draw_rect(800, 200, 300, 300, style.background2)

  -- Display Text: [Font, Text, X-Coord, Y-Coord, Color]
--   renderer.draw_text(style.font, "Marmalade & Pickles - make your choice; .", 150, 150, style.line_number2)

  -- Draw Multi-Line Text: |Font, Text, X-Coord, Y-Coord, Color| >: |x,z|
--   x, y = draw_text_multiline(style.font, "X\nZ...", 300, 300, style.text)

  -- Get Time, update last_time, elapsed_time
--   local time = system.get_time()
--   elapsed_time = time - last_time
--   last_time = time

-- --   io.write(">")
--   -- Update new status
--   renderer.draw_rect(100 + elapsed_time / 100, 100, 300, 300, style.line_highlight)



--   local ox, oy = self:get_content_offset()
--   local th = style.font:get_height()
--   local y = oy + style.padding.y + self.yoffset

--   for i = #core.log_items, 1, -1 do
--     local x = ox + style.padding.x
--     local item = core.log_items[i]
--     local time = os.date(nil, item.time)
--     x = renderer.draw_text(style.font, time, x, y, style.dim)
--     x = x + style.padding.x
--     local subx = x
--     x, y = draw_text_multiline(style.font, item.text, x, y, style.text)
--     renderer.draw_text(style.font, " at " .. item.at, x, y, style.dim)
--     renderer.draw_text(style.font, " >> " , x, y, style.dim)
--     y = y + th
--     if item.info then
--       subx, y = draw_text_multiline(style.font, item.info, subx, y, style.dim)
--       y = y + th
--     end
--     y = y + style.padding.y
--   end
end


return CanvasView
