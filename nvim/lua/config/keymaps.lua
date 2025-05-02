-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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

-- vim.api.nvim_set_keymap("n", "<leader>cc", "<cmd>lua ToggleColorColumn()<CR>", { silent = true })
-- function ToggleColorColumn()
--	vim.wo.colorcolumn = vim.wo.colorcolumn ~= "" and "" or "80"
-- end

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
-- vim: ft=lua ts=2 sw=2 et ai
