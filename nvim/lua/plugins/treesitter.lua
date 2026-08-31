-- Treesitter configuration for nvim-treesitter (new API, Neovim 0.12+)
-- highlight and indent are now Neovim builtins, enabled by default

require("nvim-treesitter").setup()
require("nvim-treesitter").install({
  "lua",
  "vim",
  "vimdoc",
  "python",
  "javascript",
  "typescript",
  "rust",
  "go",
  "html",
  "css",
  "json",
  "yaml",
  "markdown",
  "bash",
})

-- vim: ft=lua ts=2 sw=2 et ai
