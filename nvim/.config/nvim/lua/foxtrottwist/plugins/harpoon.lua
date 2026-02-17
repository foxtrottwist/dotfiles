return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		local keymap = vim.keymap

		keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Mark file with harpoon" })

		keymap.set("n", "<leader>e", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle Harpoon Menu" })

		keymap.set("n", "<leader>nn", function()
			harpoon:list():next()
		end, { desc = "Go to next harpoon mark" })

		keymap.set("n", "<leader>mm", function()
			harpoon:list():prev()
		end, { desc = "Go to previous harpoon mark" })

		keymap.set("n", "<leader>hf", function()
			local conf = require("telescope.config").values
			local items = harpoon:list().items

			local file_paths = {}
			for _, item in ipairs(items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end, { desc = "Show harpoon marks" })
	end,
}
