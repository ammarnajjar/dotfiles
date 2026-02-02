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
	-- Wrap in pcall for safety
	local success, err = pcall(function()
		vim.bo.expandtab = true -------╮
		vim.bo.smartindent = true -----|-- Default 1 tab == 4 spaces
		indentUsing(4) ----------------╯

		-- Use hash table for O(1) lookup instead of linear search
		local with_two_spaces = {
			typescript = true,
			typescriptreact = true,
			javascript = true,
			javascriptreact = true,
			lua = true,
			ruby = true,
			html = true,
			xhtml = true,
			htm = true,
			css = true,
			scss = true,
			php = true,
			json = true,
			yml = true,
			yaml = true,
			dart = true,
		}

		if vim.bo.filetype == "python" then
			pythonSetup()
		elseif with_two_spaces[vim.bo.filetype] then
			indentUsing(2)
		end
	end)

	if not success then
		vim.notify("FileTypeSetup error: " .. tostring(err), vim.log.levels.ERROR)
	end
end

vim.schedule(function()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "*",
		callback = function()
			vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = "black", bg = "black" })
		end,
	})
	vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, { callback = FileTypeSetup })
end)

-- highlight yanked text
vim.schedule(function()
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function()
			vim.highlight.on_yank({ timeout = 1000 })
		end,
	})
end)

-- delete trailing white spaces except for markdown
vim.schedule(function()
	vim.api.nvim_create_autocmd("BufWritePre", {
		callback = function(ev)
			if vim.bo.filetype == "markdown" then
				return
			end
			local save_cursor = vim.fn.getpos(".")
			-- Build pattern dynamically to avoid crash
			local pattern = "%s/" .. "\\s\\+" .. "$//ge"
			vim.cmd(pattern)
			vim.fn.setpos(".", save_cursor)
		end,
	})
end)

-- Return to last edit position when opening files
vim.schedule(function()
	vim.api.nvim_create_autocmd("BufReadPost", {
		pattern = "*",
		callback = function()
			local mark = "'" .. '"'
			local last_pos = vim.fn.line(mark)
			if last_pos > 0 and last_pos <= vim.fn.line("$") then
				local cmd = "normal! g`" .. '"'
				vim.cmd(cmd)
			end
		end,
	})
end)
-- }}}
--
-- vim: ft=lua ts=2 sw=2 et ai
