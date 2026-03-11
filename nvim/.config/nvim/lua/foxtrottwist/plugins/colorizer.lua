return {
	"NvChad/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		filetypes = { "*" },
		buftypes = {},
		user_commands = true,
		lazy_load = true,
		parsers = {
			css = true,
		},
		display = {
			mode = "background",
			names = true,
		},
	},
}
