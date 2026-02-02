-- Set leader key before loading plugins
vim.g.mapleader = ","

-- Load configuration modules
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- bootstrap lazy.nvim and plugins
require("config.lazy")

-- vim: ft=lua ts=2 sw=2 et ai
