local style = require "core.style"
local config = require "core.config"
local style = require "core.style"
local Doc

local core = {}



local function log(icon, icon_color, fmt, ...)
  local text = string.format(fmt, ...)
  if icon then
    core.status_view:show_message(icon, icon_color, text)
  end

  local info = debug.getinfo(2, "Sl")
  local at = string.format("%s:%d", info.short_src, info.currentline)
  local item = { text = text, time = os.time(), at = at }
  table.insert(core.log_items, item)
  if #core.log_items > config.max_log_items then
    table.remove(core.log_items, 1)
  end
  return item
end
function core.open_doc(filename)
  if filename then
    -- try to find existing doc for filename
    local abs_filename = system.absolute_path(filename)
    for _, doc in ipairs(core.docs) do
      if doc.filename
      and abs_filename == system.absolute_path(doc.filename) then
        return doc
      end
    end
  end
  -- no existing doc for filename; create new
  local doc = Doc(filename)
  table.insert(core.docs, doc)
  core.log_quiet(filename and "Opened doc \"%s\"" or "Opened new doc", filename)
  return doc
end

function core.init()
  RootView = require "core.rootview"
  CanvasView = require "core.canvasview"
  Doc = require "core.doc"

  core.frame_start = 0
  core.clip_rect_stack = {{ 0,0,0,0 }}
  core.log_items = {}
  core.docs = {}
  core.threads = setmetatable({}, { __mode = "k" })
  core.project_files = {}
  core.redraw = true

  core.root_view = RootView()
  core.canvas_view = CanvasView()
  local node = core.root_view:get_active_node()
  node:add_view(core.canvas_view)
--   core.root_view.root_node:split("down", core.canvas_view, true)
--   core.root_view:open_doc(core.open_doc(EXEDIR .. "/data/user/init.lua"))
  core.window_title = '.'

--   local confirm = system.show_confirm_dialog("Unsaved Changes", ">")


end

function core.add_thread(f, weak_ref)
  local key = weak_ref or #core.threads + 1
  local fn = function() return core.try(f) end
  core.threads[key] = { cr = coroutine.create(fn), wake = 0 }
end

function core.log(...)
  return log("i", style.text, ...)
end


function core.log_quiet(...)
  return log(nil, nil, ...)
end


function core.error(...)
  return log("!", style.accent, ...)
end



function core.step()

  -- handle events
  local did_keymap = false
  local mouse_moved = false
  local mouse = { x = 0, y = 0, dx = 0, dy = 0 }

  for type, a,b,c,d in system.poll_event do
    if type == "mousemoved" then
      mouse_moved = true
      mouse.x, mouse.y = a, b
      mouse.dx, mouse.dy = mouse.dx + c, mouse.dy + d
    elseif type == "textinput" and did_keymap then
      did_keymap = false
    else
      local _, res = core.try(core.on_event, type, a, b, c, d)
      did_keymap = res or did_keymap
    end
    core.redraw = true
  end
  if mouse_moved then
    core.try(core.on_event, "mousemoved", mouse.x, mouse.y, mouse.dx, mouse.dy)
  end

--    update window title
  if core.window_title and string.len(core.window_title) > 100 then
    system.set_window_title('.')
    core.window_title = '.'
  else
--     if title == nil then core.window_title = '.' end
    system.set_window_title(core.window_title .. '@')
--     print('.', core.window_title, string.len(core.window_title))
    core.window_title = core.window_title .. '.'
  end

  local width, height = renderer.get_size()

  -- update
  core.root_view.size.x, core.root_view.size.y = width, height
  core.root_view:update()
  if not core.redraw then return false end
  core.redraw = false

  -- draw
  renderer.begin_frame()
  core.clip_rect_stack[1] = { 0, 0, width, height }
  renderer.set_clip_rect(table.unpack(core.clip_rect_stack[1]))
  core.root_view:draw()
  renderer.draw_text(style.font, "Apples & Oranges; Playing with letters & Numbers.", 50, 50, style.text)
  renderer.end_frame()

  return true
end


-- Core Service
-- Runs Main Loop Drawing Procedure
function core.run()
  local start_time = system.get_time()
  while true do
    -- Get Start-Time
    core.frame_start = system.get_time()
    -- Draw a Frame
    local did_redraw = core.step()
--     run_threads()
    -- Wait IF no need to draw, and no user-focus
    if not did_redraw and not system.window_has_focus() then
      system.wait_event(0.25)
    end
    if system.get_time() - start_time > 3.5 then
      core.quit(true)
    end
--     Check elapsed time and resolve to FPS
    local elapsed = system.get_time() - core.frame_start
    system.sleep(math.max(0, 1 / 50 - elapsed))
  end
end

function core.try(fn, ...)
  local err
  local ok, res = xpcall(fn, function(msg)
    local item = core.error("%s", msg)
    item.info = debug.traceback(nil, 2):gsub("\t", "")
    err = msg
  end, ...)
  if ok then
    return true, res
  end
  return false, err
end

function core.on_event(type, ...)
  local did_keymap = false
  if type == "textinput" then
    core.root_view:on_text_input(...)
  elseif type == "keypressed" then
    did_keymap = keymap.on_key_pressed(...)
  elseif type == "keyreleased" then
    keymap.on_key_released(...)
  elseif type == "mousemoved" then
    core.root_view:on_mouse_moved(...)
  elseif type == "mousepressed" then
    core.root_view:on_mouse_pressed(...)
  elseif type == "mousereleased" then
    core.root_view:on_mouse_released(...)
  elseif type == "mousewheel" then
    core.root_view:on_mouse_wheel(...)
  elseif type == "filedropped" then
    local filename, mx, my = ...
    local info = system.get_file_info(filename)
    if info and info.type == "dir" then
      system.exec(string.format("%q %q", EXEFILE, filename))
    else
      local ok, doc = core.try(core.open_doc, filename)
      if ok then
        local node = core.root_view.root_node:get_child_overlapping_point(mx, my)
        node:set_active_view(node.active_view)
        core.root_view:open_doc(doc)
      end
    end
  elseif type == "quit" then
    core.quit()
  end
  return did_keymap
end




-- Exit Procedure
function core.quit(force)
    os.exit()
end


function core.set_active_view(view)
  assert(view, "Tried to set active view to nil")
  if view ~= core.active_view then
    core.last_active_view = core.active_view
    core.active_view = view
  end
end

function core.push_clip_rect(x, y, w, h)
  local x2, y2, w2, h2 = table.unpack(core.clip_rect_stack[#core.clip_rect_stack])
  local r, b, r2, b2 = x+w, y+h, x2+w2, y2+h2
  x, y = math.max(x, x2), math.max(y, y2)
  b, r = math.min(b, b2), math.min(r, r2)
  w, h = r-x, b-y
  table.insert(core.clip_rect_stack, { x, y, w, h })
  renderer.set_clip_rect(x, y, w, h)
end


function core.pop_clip_rect()
  table.remove(core.clip_rect_stack)
  local x, y, w, h = table.unpack(core.clip_rect_stack[#core.clip_rect_stack])
  renderer.set_clip_rect(x, y, w, h)
end


return core


