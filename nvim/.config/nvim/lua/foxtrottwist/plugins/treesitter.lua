return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local wanted = {
        "bash",
        "css",
        "dockerfile",
        "html",
        "gitignore",
        "go",
        "graphql",
        "json",
        "javascript",
        "lua",
        "markdown",
        "markdown_inline",
        "prisma",
        "regex",
        "svelte",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      }

      local missing = vim.tbl_filter(function(lang)
        return not pcall(vim.treesitter.language.inspect, lang)
      end, wanted)

      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          include_surrounding_whitespace = true,
        },
      })

      local function select_textobject(query)
        return function()
          require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
        end
      end

      local mappings = {
        { "a=", "@assignment.outer", "Select outer assignment" },
        { "i=", "@assignment.inner", "Select inner assignment" },
        { "a:", "@parameter.outer", "Select outer parameter" },
        { "i:", "@parameter.inner", "Select inner parameter" },
        { "ai", "@conditional.outer", "Select outer conditional" },
        { "ii", "@conditional.inner", "Select inner conditional" },
        { "al", "@loop.outer", "Select outer loop" },
        { "il", "@loop.inner", "Select inner loop" },
        { "ab", "@block.outer", "Select outer block" },
        { "ib", "@block.inner", "Select inner block" },
        { "af", "@function.outer", "Select outer function" },
        { "if", "@function.inner", "Select inner function" },
        { "ac", "@class.outer", "Select outer class" },
        { "ic", "@class.inner", "Select inner class" },
      }

      for _, map in ipairs(mappings) do
        vim.keymap.set({ "x", "o" }, map[1], select_textobject(map[2]), { desc = map[3] })
      end

      -- Swap keymaps
      vim.keymap.set("n", "<leader>on", function()
        require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
      end, { desc = "Swap next parameter" })

      vim.keymap.set("n", "<leader>op", function()
        require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
      end, { desc = "Swap previous parameter" })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
