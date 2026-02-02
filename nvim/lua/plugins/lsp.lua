-- LSP Configuration
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pyright",
		"ts_ls",
		"rust_analyzer",
	},
})

-- Setup language servers
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Lua
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- Python
lspconfig.pyright.setup({
	capabilities = capabilities,
})

-- TypeScript/JavaScript
lspconfig.ts_ls.setup({
	capabilities = capabilities,
})

-- Rust
lspconfig.rust_analyzer.setup({
	capabilities = capabilities,
})

-- Keymaps for LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "Go to declaration" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = args.buf, desc = "Show references" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = args.buf, desc = "Go to implementation" })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = "Hover documentation" })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = args.buf, desc = "Rename symbol" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf, desc = "Code action" })
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, { buffer = args.buf, desc = "Format buffer" })
	end,
})

-- vim: ft=lua ts=2 sw=2 et ai
