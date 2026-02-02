-- LSP Configuration
require("mason").setup()

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Disable Neovim 0.11 auto LSP detection
-- vim.g.lsp_enable = false

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pyright",
		"ts_ls",
		"eslint",
		"angularls",
		"bashls",
		"rust_analyzer",
	},
	handlers = {
		function(server_name)
			-- Skip non-LSP tools
			if server_name == "stylua" then
				return
			end
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
			})
		end,
		["lua_ls"] = function()
			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
		end,
		["ts_ls"] = function()
			local config = require("lspconfig").ts_ls
			config.setup({
				capabilities = capabilities,
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
				},
			})
			-- Clear deprecated filetypes from the default config
			config.document_config.default_config.filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			}
		end,
	},
})

-- Auto-format on save (set to true to enable)
local format_on_save = false

-- Keymaps for LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		-- Validate buffer exists
		if not vim.api.nvim_buf_is_valid(args.buf) then
			return
		end

		-- Setup auto-format on save if enabled
		if format_on_save then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = args.buf,
				callback = function()
					pcall(vim.lsp.buf.format, { async = false })
				end,
			})
		end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "Go to declaration" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = args.buf, desc = "Show references" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = args.buf, desc = "Go to implementation" })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = "Hover documentation" })
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = args.buf, desc = "Signature help" })
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = args.buf, desc = "Signature help" })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = args.buf, desc = "Rename symbol" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf, desc = "Code action" })
		vim.keymap.set("n", "<leader>f", function()
			pcall(vim.lsp.buf.format, { async = true })
		end, { buffer = args.buf, desc = "Format buffer" })

		-- Diagnostic navigation
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = args.buf, desc = "Previous diagnostic" })
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = args.buf, desc = "Next diagnostic" })
	end,
})

-- vim: ft=lua ts=2 sw=2 et ai
