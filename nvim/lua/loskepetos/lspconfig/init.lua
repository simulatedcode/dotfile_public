local lsp_status = require("lsp-status")
lsp_status.config({
	select_symbol = function(cursor_pos, symbol)
		if symbol.valueRange then
			local value_range = {
				["start"] = {
					character = 0,
					line = vim.fn.byte2line(symbol.valueRange[1]),
				},
				["end"] = {
					character = 0,
					line = vim.fn.byte2line(symbol.valueRange[2]),
				},
			}

			return require("lsp-status.util").in_range(cursor_pos, value_range)
		end
	end,
})
lsp_status.register_progress()

local nvim_lsp = require("lspconfig")

local protocol = require("vim.lsp.protocol")

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local enable_format_on_save = function(_, bufnr)
	vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup_format,
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format({ bufnr = bufnr })
		end,
	})
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	--local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	--Enable completion triggered by <c-x><c-o>
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	lsp_status.on_attach(client)
end

protocol.CompletionItemKind = {
	"", -- Text
	"", -- Method
	"", -- Function
	"", -- Constructor
	"", -- Field
	"", -- Variable
	"", -- Class
	"ﰮ", -- Interface
	"", -- Module
	"", -- Property
	"", -- Unit
	"", -- Value
	"", -- Enum
	"", -- Keyword
	"﬌", -- Snippet
	"", -- Color
	"", -- File
	"", -- Reference
	"", -- Folder
	"", -- EnumMember
	"", -- Constant
	"", -- Struct
	"", -- Event
	"ﬦ", -- Operator
	"", -- TypeParameter
}

-- Set up completion using nvim_cmp with LSP source
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

nvim_lsp.tailwindcss.setup({
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
	on_attach = lsp_status.on_attach,
	capabilities = lsp_status.capabilities,
	flags = lsp_flags,
})

-- rust setup
nvim_lsp.rust_analyzer.setup({
	on_attach = lsp_status.on_attach,
	flags = lsp_flags,
	capabilities = lsp_status.capabilities,
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
				importPrefix = "by_self",
			},
			cargo = {
				loadOutDirsFromCheck = true,
			},
			checkOnSave = {
				command = "clippy",
			},
			procMacro = {
				enable = true,
			},
		},
	},
})

nvim_lsp.astro.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.cssls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.intelephense.setup({
	on_attach = on_attach,
	filetypes = { "php" },
	cmd = { "intelephense", "--stdio" },
	flags = lsp_flags,
	capabilities = capabilities,
})

nvim_lsp.volar.setup({
	init_options = {
		typescript = {
			tsdk = "/usr/local/lib/node_modules/typescript/lib",
		},
	},
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.tsserver.setup({
	on_attach = on_attach,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	cmd = { "typescript-language-server", "--stdio" },
	capabilities = capabilities,
})

nvim_lsp.sumneko_lua.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		enable_format_on_save(client, bufnr)
	end,
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},

			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	update_in_insert = false,
	--virtual_text = { spacing = 4, prefix = "●" },
	severity_sort = true,
})

-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = true,
	float = {
		source = "always", -- Or "if_many"
	},
})

vim.api.nvim_create_autocmd("CursorHold", {
	buffer = bufnr,
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ● ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})

vim.o.updatetime = 250

require("loskepetos.lspconfig.mason")
require("loskepetos.lspconfig.null-ls")
require("loskepetos.lspconfig.lspsaga")
