-- => Header ---------------------- {{{
-- Fie: init.lua
-- Author: Ammar Najjar <najjarammar@protonmail.com>
-- Description: My neovim lua configurations file
-- }}}
-- => General ---------------------- {{{
--- Change leader key to ,
vim.g.mapleader = ","
local editor_root = vim.fn.expand("~/.config/nvim/")

local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function file_exists(name)
	local fi = io.open(name, "r")
	if fi ~= nil then
		io.close(fi)
		return true
	else
		return false
	end
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
vim.g.python3_host_prog = call_shell(which_python)

vim.o.mouse = "a" -------- Enable mouse usage (all modes)
vim.o.matchtime = 1 ------ for 1/10th of a second
vim.o.showmatch = true --- Show matching brackets.
vim.o.ignorecase = true -- Do case insensitive matching
vim.o.smartcase = true --- Do smart case matching
vim.o.hidden = true ------ Hide buffers when they are abandoned
vim.wo.number = true
vim.o.modelines = 2
vim.bo.modeline = true
vim.o.filetype = "on"

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
vim.fn.execute("set undodir=" .. editor_root .. "/undo/")

vim.cmd("set shada^=%") ------- Remember info about open buffers on close

vim.g.switchbuf = "useopen,usetab,newtab"
vim.g.showtabline = 2

vim.api.nvim_set_keymap("v", "<", "<gv", {}) --╮-- visual shifting
vim.api.nvim_set_keymap("v", ">", ">gv", {}) --╯

-- Edit the vimrc file
vim.api.nvim_set_keymap("n", "<leader>ev", "<cmd>tabe $MYVIMRC<CR>", {})

-- Opens a new tab with the current buffer's path
vim.api.nvim_set_keymap("n", "<leader>te", ':tabedit <C-r>=expand("%:p:h")<CR>/', {})

-- Switch CWD to the directory of the open buffer
vim.api.nvim_set_keymap("", "<leader>cd", "<cmd>cd %:p:h<CR>:pwd<CR>", {})

-- Toggle spell checking
vim.api.nvim_set_keymap("n", "<leader>ss", "<cmd>setlocal spell!<CR>", {})

-- Terminal mode mappings
vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n>", {})
vim.api.nvim_set_keymap("n", "<leader>s", "<cmd>split term://" .. "$SHELL" .. "<CR><C-w><S-j><S-a>", {})
vim.api.nvim_set_keymap("n", "<leader>v", "<cmd>vsplit term://" .. "$SHELL" .. "<CR><C-w><S-l><S-a>", {})
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>tabedit term://" .. "$SHELL" .. "<CR><S-a>", {})
vim.api.nvim_create_autocmd("TermOpen", { pattern = "*", command = "setlocal nonumber statusline=%{b:term_title}" })

-- view hidden characters by default
vim.o.listchars = "tab:>-,space:·,nbsp:␣,trail:•,eol:↲,precedes:«,extends:»,conceal:┊"
vim.api.nvim_set_keymap("n", "<F2>", "<cmd>setlocal list! list? <CR>", { noremap = true })

-- Allow toggling between tabs and spaces
vim.api.nvim_set_keymap("n", "<F3>", "<cmd>lua TabToggle()<cr>", {})
function TabToggle()
	if vim.bo.expandtab then
		vim.bo.expandtab = false
		vim.cmd("retab!")
	else
		vim.bo.expandtab = true
		vim.cmd("retab")
	end
end

-- Toggle ColumnColor
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.api.nvim_command("highlight ColorColumn ctermbg=black guibg=black")
	end,
})
vim.api.nvim_set_keymap("n", "<leader>cc", "<cmd>lua ToggleColorColumn()<CR>", { silent = true })
function ToggleColorColumn()
	vim.wo.colorcolumn = vim.wo.colorcolumn ~= "" and "" or "80"
end

-- Append modeline after last line in buffer
vim.api.nvim_set_keymap("n", "<Leader>ml", "<cmd>lua AppendModeline()<CR>", { silent = true })
function AppendModeline()
	local mine = string.format(
		"vim: ft=%s ts=%d sw=%d %set %sai",
		vim.bo.filetype,
		vim.bo.tabstop,
		vim.bo.shiftwidth,
		vim.bo.expandtab and "" or "no",
		vim.bo.autoindent and "" or "no"
	)
	local modeline = { string.format(vim.bo.commentstring, mine) }
	vim.api.nvim_buf_set_lines(0, -1, -1, true, modeline)
end
--}}}
-- => Plugins ---------------- {{{
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

		-- disable some default plugins
		{ "echasnovski/mini.pairs", enabled = false },
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

-- trouble
vim.keymap.set("n", "<leader>xx", function()
	require("trouble").toggle()
end)

-- git-blame
vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
vim.g.gitblame_date_format = "%x"
vim.g.gitblame_message_template = "  <sha> • <date> • <author> • <summary>"
local git_blame = require("gitblame")
local function blame_message()
	local text = git_blame.get_current_blame_text()
	return string.sub(text, 1, 100)
end
require("lualine").setup({
	options = { theme = "auto" },
	sections = {
		lualine_c = {
			{ blame_message, cond = git_blame.is_blame_text_available },
		},
	},
})

-- colorscheme
vim.wo.cursorline = true

local function LightTheme()
	vim.o.background = "light"
	vim.api.nvim_create_autocmd("BufEnter", { command = "highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254" })
	vim.api.nvim_create_autocmd(
		"BufEnter",
		{ command = "highlight cursorlinenr term=bold ctermfg=black ctermbg=grey gui=bold guifg=white guibg=grey" }
	)
	vim.api.nvim_create_autocmd(
		"insertenter",
		{ command = "highlight cursorlinenr term=bold ctermfg=black ctermbg=117 gui=bold guifg=white guibg=skyblue1" }
	)
	vim.api.nvim_create_autocmd(
		"insertenter",
		{ command = "highlight cursorline cterm=none ctermfg=none ctermbg=none" }
	)
	vim.api.nvim_create_autocmd(
		"insertleave",
		{ command = "highlight cursorlinenr term=bold ctermfg=black ctermbg=grey gui=bold guifg=white guibg=grey" }
	)
	vim.api.nvim_create_autocmd("InsertLeave", { command = "highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=254" })
end
local function DarkTheme()
	vim.o.background = "dark"
	vim.g.nvcode_termcolors = 256
	pcall(function()
		vim.cmd("colorscheme nvcode")
	end) -- try colorscheme, fallback to default

	vim.api.nvim_set_hl(
		0,
		"CursorLineNr",
		{ background = "black", foreground = "yellow", ctermfg = "yellow", ctermbg = "black", bold = true }
	)
	vim.api.nvim_create_autocmd(
		"InsertEnter",
		{ command = "highlight CursorLineNr term=bold ctermfg=black ctermbg=74 gui=bold guifg=black guibg=skyblue1" }
	)
	vim.api.nvim_create_autocmd(
		"InsertLeave",
		{ command = "highlight CursorLineNr term=bold ctermfg=yellow ctermbg=black gui=bold guifg=yellow guibg=black" }
	)
end

if vim.env.KONSOLE_PROFILE_NAME == "light" or vim.env.ITERM_PROFILE == "light" then
	LightTheme()
else
	DarkTheme()
end

-- completion
vim.cmd([[set completeopt=menuone,noinsert,noselect]])
vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy" }

-- fzf
vim.g.fzf_layout = { down = "~40%", window = "enew" }
vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>Files<cr>", {})

-- grep text under cursor
vim.api.nvim_set_keymap("n", "<leader>rg", ":Rg <C-R><C-W><CR>", {})
vim.api.nvim_set_keymap("n", "<leader>ag", ":Ag <C-R><C-W><CR>", {})

-- [Buffers] Jump to the existing window if possible
vim.g.fzf_buffers_jump = 1

-- [Commits] Customize the options used by 'git log':
vim.g.fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

-- [Tags] Command to generate tags file
vim.g.fzf_tags_command =
	'ctags --append=no --recurse --exclude=blib --exclude=dist --exclude=node_modules --exclude=coverage --exclude=.svn --exclude=.get --exclude="@.gitignore" --extra=q'

-- show preview with colors using bat if exists
if vim.fn.executable("bat") ~= 0 then
	vim.env.FZF_DEFAULT_OPTS = "--ansi --preview-window 'right:60%' --margin=1 --preview 'bat --line-range :150 {}'"
end

-- use ripgrep if exists
if vim.fn.executable("rg") ~= 0 then
	vim.env.FZF_DEFAULT_COMMAND =
		'rg --hidden --files --glob="!.git/*" --glob="!venv/*" --glob="!coverage/*" --glob="!node_modules/*" --glob="!target/*" --glob="!__pycache__/*" --glob="!dist/*" --glob="!build/*" --glob="!*.DS_Store"'
	vim.api.nvim_set_option_value("grepprg", "rg --vimgrep --smart-case --follow", { scope = "global" })
elseif vim.fn.executable("ag") ~= 0 then
	vim.env.FZF_DEFAULT_COMMAND =
		'ag --hidden --ignore .git --ignore venv/ --ignore coverage/ --ignore node_modules/ --ignore target/  --ignore __pycache__/ --ignore dist/ --ignore build/ --ignore .DS_Store  -g ""'
	vim.api.nvim_set_option_value("grepprg", "ag", { scope = "global" })
else
	-- else fallback to find
	vim.env.FZF_DEFAULT_COMMAND =
		[[find * -path '*/\.*' -prune -o -path 'venv/**' -prune -o -path  'coverage/**' -prune -o -path 'node_modules/**' -prune -o -path '__pycache__/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null]]
end

-- use fd if exists
if vim.fn.executable("fd") ~= 0 then
	vim.env.FZF_DEFAULT_COMMAND =
		'fd --type f --follow --hidden --exclude=".git/*" --exclude="venv/*" --exclude="coverage/*" --exclude="node_modules/*" --exclude="target/*" --exclude="__pycache__/*" --exclude="dist/*" --exclude="build/*" --exclude="*.DS_Store"'
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>p", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>=", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

-- => autocmd configs ---------------------- {{{
local function indentUsing(indent)
	vim.bo.shiftwidth = indent
	vim.bo.tabstop = indent
	vim.bo.softtabstop = indent
end

local function pythonSetup()
	indentUsing(4)
	vim.bo.formatoptions = vim.bo.formatoptions .. "croq"
	vim.bo.cinwords = "if,elif,else,for,while,try,except,finally,def,class,with"
end

function FileTypeSetup()
	vim.bo.expandtab = true -------╮
	vim.bo.smartindent = true -----|-- Default 1 tab == 4 spaces
	indentUsing(4) ----------------╯

	local with_two_spaces = {
		"typescript",
		"typescript.tsx",
		"javascript",
		"javascript.jsx",
		"lua",
		"ruby",
		"html",
		"xhtml",
		"htm",
		"css",
		"scss",
		"php",
		"json",
		"yml",
		"yaml",
		"dart",
	}
	if vim.bo.filetype == "python" then
		pythonSetup()
	else
		for _, filetype in pairs(with_two_spaces) do
			if vim.bo.filetype == filetype then
				indentUsing(2)
				break
			end
		end
	end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, { callback = FileTypeSetup })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", { command = "silent! lua vim.highlight.on_yank({ timeout=1000 } )" })

-- highlight trailing whitespaces
vim.api.nvim_set_hl(0, "TrailingWhitespace", { background = tonumber("0xDC1B1B") })
vim.api.nvim_create_autocmd("InsertEnter", { pattern = "*.*", command = "match TrailingWhitespace /\\s\\+\\%#\\@<!$/" })
vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*.*", command = "match TrailingWhitespace /\\s\\+$/" })

-- delete trailing white spaces except for markdown
function DeleteTrailingWS()
	if vim.bo.filetype == "markdown" then
		return
	end
	vim.api.nvim_command([[normal mz]])
	vim.cmd([[%s/\s\+$//ge]])
	vim.api.nvim_command([[normal 'z]])
end
vim.api.nvim_create_autocmd("BufWritePre", { callback = DeleteTrailingWS })

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", { pattern = "*", command = "silent! normal! g;" })
-- }}}
-- => Statusline ---------------------- {{{
function TabsFound()
	local curline = vim.api.nvim_buf_get_lines(0, 0, 1000, false)
	for _, value in ipairs(curline) do
		if string.find(value, "\t+") then
			return "[tabs]"
		end
	end
	return ""
end

function HasPaste()
	return vim.o.paste and "[paste]" or ""
end

function GitBranch()
	local get_head_command = "command -v git >/dev/null 2>&1 && git rev-parse --abbrev-ref HEAD"
	local git_head = call_shell(get_head_command)
	return git_head ~= "" and "[git:" .. call_shell(get_head_command) .. "]" or ""
end

-- => local.lua  ---------------------- {{{
local localFile = editor_root .. "local.lua"
-- paste from register "rp
-- vim.fn.setreg({regname}, {value} [, {options}])
if file_exists(localFile) then
	loadfile(localFile)()
end
-- }}}
-- vim: ft=lua ts=2 sw=2 et ai
