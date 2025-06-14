local keymap = vim.keymap

---------------------
-- General Keymaps
---------------------

keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
keymap.set({ "n", "v", "i" }, "<C-z>", "<Nop>", { silent = true })

keymap.set("n", "<leader>w", ":w!<CR>", { silent = true, desc = "Fast saving." })

keymap.set({ "n", "v" }, "<leader>pp", "<C-^>", { desc = "Return to previously edited buffer." })

keymap.set({ "n", "v" }, "<S-U>", "<C-R>", { desc = "More intuitive redo" })

keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart lsp server." })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

keymap.set("n", "x", '"_x', { desc = "Delete single character without copying into register." })

keymap.set({ "n", "v", "i" }, "<A-Down>", ":m .+1<CR>==", { desc = "Moving line down.", silent = true })
keymap.set({ "n", "v", "i" }, "<A-up>", ":m .-2<CR>==", { desc = "Moving line down.", silent = true })

-- keep cursor in the middle of the screen when using <C-d> & <C-u>
vim.keymap.set("n", "<C-f>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make split windows equal width & height" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split window" })

----------------------
-- Plugin Keybinds
----------------------

-- vim-doge
keymap.set("n", "<leader>gg", ":DogeGenerate<CR>", { desc = "Generate docs for supported languages." })

-- gitsigns
keymap.set(
  "n",
  "<leader>tb",
  ":Gitsigns toggle_current_line_blame<CR>",
  { desc = "Toggle Git line blame.", silent = true }
)
keymap.set("n", "<leader>td", ":Gitsigns toggle_deleted<CR>", { desc = "Toggle deleted lines.", silent = true })

-- oil
keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })

-- trouble
keymap.set("n", "<leader>xx", function()
  require("trouble").toggle()
end)
keymap.set("n", "<leader>xw", function()
  require("trouble").toggle("workspace_diagnostics")
end)
keymap.set("n", "<leader>xd", function()
  require("trouble").toggle("document_diagnostics")
end)
keymap.set("n", "<leader>xq", function()
  require("trouble").toggle("quickfix")
end)
keymap.set("n", "<leader>xl", function()
  require("trouble").toggle("loclist")
end)
keymap.set("n", "<leader>xr", function()
  require("trouble").toggle("lsp_references")
end)

-- undo-tree
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Open Undotree." })

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", { desc = "Toggle split window maximization." })

-- zen-mode
keymap.set("n", "<leader>zz", "<cmd>ZenMode<CR>", { desc = "Toggle zen mode." })
