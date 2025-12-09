return { -- Add indentation guides even on blank lines
	"lukas-reineke/indent-blankline.nvim",
	-- Enable `lukas-reineke/indent-blankline.nvim`
	main = "ibl",
	-- See `:help indent_blankline.txt`
	opts = {
		indent = { char = "┊" },
	},
}
