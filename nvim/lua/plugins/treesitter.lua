-- Treesitter configuration
require("nvim-treesitter.configs").setup({
	ensure_installed = {
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
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
})

-- vim: ft=lua ts=2 sw=2 et ai
