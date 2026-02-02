-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.relativenumber = false

local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function call_shell(command)
	local handle = io.popen(command)
	if handle ~= nil then
		local result = handle:read("*a")
		handle:close()
		return trim(result)
	end
end

-- find the python3 binary for neovim
local which_python
if vim.env.VIRTUAL_ENV and vim.env.MISE_SHELL then
	which_python = "which -a python3 | head -n3 | tail -n1"
elseif vim.env.VIRTUAL_ENV then
	which_python = "which -a python3 | tail -n2 | head -n1"
elseif vim.env.MISE_SHELL then
	which_python = "which -a python3 | head -n1"
else
	which_python = "which python3"
end

local python_path = call_shell(which_python) or "python3"
if python_path and python_path ~= "" then
	if vim.fn.executable(python_path) == 1 then
		vim.g.python3_host_prog = python_path
	else
		vim.g.python3_host_prog = "python3"
		vim.notify("Warning: Python3 not found at " .. python_path .. ", using default", vim.log.levels.WARN)
	end
else
	vim.g.python3_host_prog = "python3"
	vim.notify("Warning: Could not determine Python3 path, using default", vim.log.levels.WARN)
end

vim.o.mouse = "a" -------- Enable mouse usage (all modes)
vim.o.matchtime = 1 ------ for 1/10th of a second
vim.o.showmatch = true --- Show matching brackets.
vim.o.ignorecase = true -- Do case insensitive matching
vim.o.smartcase = true --- Do smart case matching
vim.o.hidden = true ------ Hide buffers when they are abandoned
vim.wo.number = true
vim.o.modelines = 2
vim.bo.modeline = true

-- Ignore compile/build files
vim.o.wildignore = vim.o.wildignore
	.. table.concat({
		"*.o",
		"*.obj",
		".git",
		"*.rbc",
		"*.pyc",
		"__pycache__",
		"*~",
		"*.class",
		"*.git/*",
		"*.hg/*",
		"*.svn/*",
		"*/node_modules/*",
		"*/.dist/*",
		"*/.coverage/*",
	})

vim.o.joinspaces = false -- when joining lines, don't insert two spaces after '.', '?' or '!'

vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
-- set termguicolors to enable highlight groups
vim.o.termguicolors = true

vim.o.writebackup = false --╮-- Turn backup off
vim.o.swapfile = false -----╯

vim.o.inccommand = "nosplit" -- Live substitution

-- create undo file to keep history after closing the file
vim.bo.undofile = true
local editor_root = vim.fn.expand("~/.config/nvim/")
vim.opt.undodir = editor_root .. "undo/"

vim.opt.shada:prepend("%") ------- Remember info about open buffers on close

vim.g.switchbuf = "useopen,usetab,newtab"
vim.g.showtabline = 2

-- colorscheme
vim.wo.cursorline = true

local function LightTheme()
	vim.o.background = "light"

	-- Create augroup to prevent duplicate autocmds
	local group = vim.api.nvim_create_augroup("LightThemeHighlights", { clear = true })

	-- Set initial highlights
	vim.api.nvim_set_hl(0, "CursorLine", { cterm = { bold = false }, ctermbg = 254 })
	vim.api.nvim_set_hl(0, "CursorLineNr", {
		ctermfg = "black",
		ctermbg = "grey",
		fg = "white",
		bg = "grey",
		bold = true,
	})

	-- Update highlights on mode change
	vim.api.nvim_create_autocmd("InsertEnter", {
		group = group,
		callback = function()
			vim.api.nvim_set_hl(0, "CursorLineNr", {
				ctermfg = "black",
				ctermbg = 117,
				fg = "white",
				bg = "skyblue1",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "CursorLine", { cterm = {}, ctermbg = "NONE" })
		end,
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		group = group,
		callback = function()
			vim.api.nvim_set_hl(0, "CursorLineNr", {
				ctermfg = "black",
				ctermbg = "grey",
				fg = "white",
				bg = "grey",
				bold = true,
			})
			vim.api.nvim_set_hl(0, "CursorLine", { cterm = { bold = false }, ctermbg = 254 })
		end,
	})
end

local function DarkTheme()
	vim.o.background = "dark"
	vim.g.nvcode_termcolors = 256
	pcall(function()
		vim.cmd("colorscheme nvcode")
	end)

	-- Create augroup to prevent duplicate autocmds
	local group = vim.api.nvim_create_augroup("DarkThemeHighlights", { clear = true })

	-- Set initial highlight
	vim.api.nvim_set_hl(0, "CursorLineNr", {
		ctermfg = "yellow",
		ctermbg = "black",
		fg = "yellow",
		bg = "black",
		bold = true,
	})

	-- Update highlights on mode change
	vim.api.nvim_create_autocmd("InsertEnter", {
		group = group,
		callback = function()
			vim.api.nvim_set_hl(0, "CursorLineNr", {
				ctermfg = "black",
				ctermbg = 74,
				fg = "black",
				bg = "skyblue1",
				bold = true,
			})
		end,
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		group = group,
		callback = function()
			vim.api.nvim_set_hl(0, "CursorLineNr", {
				ctermfg = "yellow",
				ctermbg = "black",
				fg = "yellow",
				bg = "black",
				bold = true,
			})
		end,
	})
end

if vim.env.KONSOLE_PROFILE_NAME == "light" or vim.env.ITERM_PROFILE == "light" then
	LightTheme()
else
	DarkTheme()
end

-- completion
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy" }

-- highlight trailing whitespaces with delay
vim.schedule(function()
	vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#DC1B1B" })
	local pattern = [[\s\+$]]
	vim.fn.matchadd("TrailingWhitespace", pattern)
end)

-- => local.lua  ---------------------- {{{
local localFile = editor_root .. "local.lua"
-- paste from register "rp
-- vim.fn.setreg({regname}, {value} [, {options}])
local function file_exists(name)
	local fi = io.open(name, "r")
	if fi ~= nil then
		io.close(fi)
		return true
	else
		return false
	end
end
if file_exists(localFile) then
	loadfile(localFile)()
end
-- }}}
-- vim: ft=lua ts=2 sw=2 et ai
