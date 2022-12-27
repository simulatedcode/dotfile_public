require("nightfox").setup({
	options = {
		terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
		dim_inactive = false, -- Non focused panes set to alternative background
		module_default = true, -- Default enable value for modules
		styles = {
			comments = "italic", -- Comment style
			functions = "italic", -- Function style
			keywords = "italic,bold", -- Keyword style
			strings = "NONE", -- String style
			variables = "italic", -- Variable style
		},
	},
})

vim.cmd("colorscheme nordfox")
