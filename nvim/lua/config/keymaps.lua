-- Custom keymaps

-- Visual shifting (keeps selection after indent)
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Edit the vimrc file
vim.keymap.set("n", "<leader>ev", function()
	vim.cmd("tabedit " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Edit vimrc" })

-- Opens a new tab with the current buffer's path
vim.keymap.set("n", "<leader>te", ':tabedit <C-r>=expand("%:p:h")<CR>/', { desc = "Open tab with buffer path" })

-- Switch CWD to the directory of the open buffer
vim.keymap.set("n", "<leader>cd", "<cmd>cd %:p:h<CR>:pwd<CR>", { desc = "CD to buffer directory" })

-- Toggle spell checking
vim.keymap.set("n", "<leader>ss", "<cmd>setlocal spell!<CR>", { desc = "Toggle spell check" })

-- Terminal mode: ESC to exit terminal mode
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- View hidden characters
vim.keymap.set("n", "<F2>", "<cmd>setlocal list!<CR>", { desc = "Toggle hidden characters" })

-- Allow toggling between tabs and spaces
local function tab_toggle()
	vim.bo.expandtab = not vim.bo.expandtab
	print("Using " .. (vim.bo.expandtab and "spaces" or "tabs"))
end
vim.keymap.set("n", "<F3>", tab_toggle, { desc = "Toggle tabs/spaces" })

-- Append modeline after last line in buffer
local function append_modeline()
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
vim.keymap.set("n", "<Leader>ml", append_modeline, { desc = "Append modeline", silent = true })
-- vim: ft=lua ts=2 sw=2 et ai
