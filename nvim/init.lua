require "config.options"
require "config.keymaps"
require "config.autocmds"
require "config.lazy"

-- Optional machine-specific settings.
local local_config = vim.fn.stdpath "config" .. "/lua/config/local.lua"

if vim.uv.fs_stat(local_config) then
  require "config.local"
end
