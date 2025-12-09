return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		auto_close = false,
		auto_open = false,
		auto_preview = true,
		auto_refresh = true,
		focus = false,
		modes = {
			diagnostics = {
				auto_open = false,
			},
		},
		icons = {
			indent = {
				middle = "├╌",
				last = "└╌",
				top = "│ ",
				ws = "  ",
			},
		},
	},
}
