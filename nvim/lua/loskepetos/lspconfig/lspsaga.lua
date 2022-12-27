local keymap = vim.keymap.set
local saga = require("lspsaga")

saga.init_lsp_saga({
	symbol_in_winbar = {
		in_custom = true,
	},
})

-- Keymapping diagnostic
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
keymap({ "n", "v" }, "<space>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
keymap("n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
keymap("n", "<space>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
keymap("n", "[E", function()
	require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
	require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "<space>o", "<cmd>LSoutlineToggle<CR>", { silent = true })
keymap("n", "<space>K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

local function get_file_name(include_path)
	---@diagnostic disable-next-line: missing-parameter
	local file_name = require("lspsaga.symbolwinbar").get_file_name()
	if vim.fn.bufname("%") == "" then
		return ""
	end
	if include_path == true then
		return file_name
	end
	-- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
	local sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
	local path_list = vim.split(string.gsub(vim.fn.expand("%:~:.:h"), "%%", ""), sep)
	local file_path = ""
	for _, cur in ipairs(path_list) do
		file_path = (cur == "." or cur == "~") and "" or file_path .. cur .. " " .. "%#LspSagaWinbarSep#>%*" .. " %*"
	end
	return file_path .. file_name
end

local function config_winbar_or_statusline()
	local exclude = {
		["terminal"] = true,
		["toggleterm"] = true,
		["prompt"] = true,
		["NvimTree"] = true,
		["help"] = true,
	} -- Ignore float windows and exclude filetype
	if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
		vim.wo.winbar = ""
	else
		local ok, lspsaga = pcall(require, "lspsaga.symbolwinbar")
		local sym
		if ok then
			sym = lspsaga.get_symbol_node()
		end
		local win_val = ""
		win_val = get_file_name(true) -- set to true to include path
		if sym ~= nil then
			win_val = win_val .. sym
		end
		vim.wo.winbar = win_val
		-- if work in statusline
		--vim.wo.stl = win_val
	end
end

local events = { "BufEnter", "BufWinEnter", "CursorMoved" }

vim.api.nvim_create_autocmd(events, {
	pattern = "*",
	callback = function()
		config_winbar_or_statusline()
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "LspsagaUpdateSymbol",
	callback = function()
		config_winbar_or_statusline()
	end,
})
