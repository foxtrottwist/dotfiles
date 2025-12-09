return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		local catppuccin = require("catppuccin")

		catppuccin.setup({
			flavour = "macchiato",

			integrations = {
				alpha = true,
				cmp = true,
				fidget = true,
				gitsigns = true,
				harpoon = true,
				lsp_saga = true,
				lsp_trouble = true,
				markdown = true,
				mason = true,
				telescope = { enabled = true },
				treesitter = true,
				which_key = true,
			},
		})

		vim.cmd([[colorscheme catppuccin]])
	end,
}
