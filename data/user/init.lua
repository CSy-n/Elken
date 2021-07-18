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


