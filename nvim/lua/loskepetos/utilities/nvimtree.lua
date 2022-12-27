vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local glyphs = {}

local installed, circles = pcall(require, "circles")
if installed then
	circles.setup({ icons = { empty = "", filled = "", lsp_prefix = "" } })
	glyphs = circles.get_nvimtree_glyphs()
end

glyphs.git = {
	unstaged = "",
	staged = "",
	unmerged = "",
	renamed = "",
	untracked = "",
	deleted = "",
	ignored = "",
}

require("nvim-tree").setup({
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	diagnostics = { enable = true },
	view = {
		width = 32,
		side = "left",
		signcolumn = "no",
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 500,
	},
	actions = {
		open_file = {
			quit_on_open = false,
			window_picker = {
				enable = false,
			},
		},
	},
	renderer = {
		group_empty = true,
		highlight_opened_files = "all",
		special_files = {},
		root_folder_modifier = ":p:~",
		icons = {
			glyphs = glyphs,
		},
	},
})

-- Mappings
vim.keymap.set("n", "<space>e", function()
	require("nvim-tree").toggle()
end, { noremap = true, silent = true })
