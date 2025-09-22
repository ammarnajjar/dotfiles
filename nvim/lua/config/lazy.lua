-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{
			"ammarnajjar/nvcode-color-schemes.vim",
			lazy = false,
			config = function()
				vim.cmd([[colorscheme nvcode]])
			end,
		},
		-- add LazyVim and import its plugins
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			opts = {
				colorscheme = "nvcode",
			},
		},
		{ "f-person/git-blame.nvim" },

		-- change some default plugins
		{
			"folke/snacks.nvim",
			opts = {
				dashboard = {
					-- your dashboard configuration comes here
					sections = {
						{ section = "keys", gap = 1, padding = 1 },
						{ section = "startup" },
					},
				},
			},
		},
		{ "nvim-mini/mini.pairs", enabled = false },
		{ "folke/flash.nvim", enabled = false },
		{ "folke/todo-comments.nvim", enabled = false },
		-- import/override with your plugins
		-- { import = "plugins" },
	},
	defaults = {
		lazy = true,
	},
	install = { colorscheme = { "nvcode" } },
	checker = {
		enabled = true, -- check for plugin updates periodically
		notify = false, -- notify on update
	}, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- vim: ft=lua ts=2 sw=2 et ai
