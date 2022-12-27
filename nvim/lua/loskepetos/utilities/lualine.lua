local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn", "info", "hint" },
	symbols = { error = " ", warn = " ", info = " ", hint = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

-- local mode = {
-- 	"mode",
-- 	fmt = function(str)
-- 		return "-- " .. str .. " --"
-- 	end,
-- }

-- local filetype = {
-- 	"filetype",
-- 	icons_enabled = true,
-- 	icon = nil,
-- }

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 1,
}

lualine.setup({
	enabled = true,
	winbar_width = "100%",
	winbar_autoshow = true,
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "toggleterm" },
		always_divide_middle = true,
	},
	sections = {

		lualine_a = { branch },
		lualine_b = { diagnostics },
		lualine_c = {
			{
				"diff",
				colored = false,
				symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
				cond = hide_in_width,
			},
			-- {
			-- 	"filename",
			-- 	file_status = true, -- displays file status (readonly status, modified status)
			-- 	path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
			-- },
		},
		--lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_x = {
			--{ "aerial", sep = "  " },
			{ "lsp_spinner" },
			{ "filetype" },
			{ "fileformat" },
			{ "encoding" },
		},
		lualine_y = { location },
		lualine_z = { "progress" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extentions = {},
})
