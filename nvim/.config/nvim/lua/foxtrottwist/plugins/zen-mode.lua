return { -- zen mode
	"folke/zen-mode.nvim",
	dependencies = { "folke/twilight.nvim" },
	opts = {
		window = {
			width = 120,
		},

		plugins = {
			twilight = { enabled = true },
		},
	},
}
