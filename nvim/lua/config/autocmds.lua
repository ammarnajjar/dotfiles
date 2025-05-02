-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.api.nvim_command("highlight ColorColumn ctermbg=black guibg=black")
	end,
})

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

-- -- Return to last edit position when opening files
-- vim.api.nvim_create_autocmd("BufReadPost", { pattern = "*", command = "silent! normal! g;" })
-- }}}
--
-- vim: ft=lua ts=2 sw=2 et ai
