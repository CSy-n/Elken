local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"

local predefined_imports = '\
  local core = require "core"\
  local style = require "core.style"\
  local command = require "core.command"\
  local common = require "core.common"\
  local config = require "core.config"\n'

local function eval(str)
  local fn, err = load(predefined_imports .. "return " .. str)
  if not fn then fn, err = load(predefined_imports .. str) end
  assert(fn, err)
  return tostring(fn())
end
-- So I'm trying to evaluate the code `style` such that it retains the properties in
-- `data/core/style.lua`
--- ... Ctrl + e or Ctrl + T  [[ /m/ ]]
-- print("X")
-- for k,v in pairs(style) do print(k,v) end
-- style
-- style
command.add("core.docview", {
  ["eval:evaluate"] = function()
    core.command_view:enter("Evaluate And Insert Result", function(cmd)
--     declare ( :introspector, :eval::evaluate, "command-evaluation-output" {
--       print(predefined_imports .. cmd)
--     })
      print(predefined_imports .. cmd)
--       print(type(cmd))
      -- check: no-command-specified
      if string.len(cmd) == 0 then return end
      core.active_view.doc:text_input(eval(cmd))
    end)
  end,

  ["eval:replace"] = function()
    core.active_view.doc:replace(eval)
  end,

  ["eval:append"] = function()
    core.active_view.doc:replace(function (...)
      -- TODO: Evaluator::append -- check ends-with :new-line-universal
      return ... .. '\n' .. eval(...)
    end)
  end,
})

keymap.add {
--   ["ctrl+x"] = "console:toggle",
  ["ctrl+t"] = "eval:evaluate",
  ["ctrl+e"] = "eval:append",
--   ["ctrl+k"] = "console:asd",
--   ["ctrl+shift+."] = "console:run",

}

