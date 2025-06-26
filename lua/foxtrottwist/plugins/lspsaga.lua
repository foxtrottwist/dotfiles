return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local saga = require("lspsaga")

		saga.setup({
			-- keybinds for navigation in lspsaga window
			scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
			-- use enter to open file with definition preview
			definition = {
				keys = {
					edit = "<CR>",
				},
				-- Fix cursor position errors with multiple LSPs
				save_pos = false,
			},
			ui = {
				-- border type can be single,double,rounded,solid,shadow.
				border = "rounded",
				winblend = 0,
				colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
				kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
			},
		})
	end,
}
