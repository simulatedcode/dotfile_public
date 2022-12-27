local status, bufferline = pcall(require, "bufferline")
if not status then
	return
end

bufferline.setup({
	options = {
		mode = "buffers",
		separator_style = "slant",
		always_show_bufferline = false,
		show_buffer_close_icons = true,
		show_close_icon = false,
		color_icons = true,
		height = 30,
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "left",
				highlight = "Directory",
				padding = 1,
			},
		},
	},
})
