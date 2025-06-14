return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      -- import nvim-treesitter plugin safely
      local ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter not found", vim.log.levels.ERROR)
        return
      end

      -- configure treesitter
      treesitter.setup({ -- enable syntax highlighting
        highlight = {
          enable = true,
        },
        -- enable indentation
        indent = { enable = true },
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = { enable = true },
        -- ensure these language parsers are installed
        ensure_installed = {
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
        },
        -- auto install above language parsers
        auto_install = true,
      })
      
      -- setup ts_context_commentstring separately with error handling
      local ts_ok, _ = pcall(require, "ts_context_commentstring")
      if ts_ok then
        require("ts_context_commentstring").setup({})
      else
        vim.notify("ts_context_commentstring not found", vim.log.levels.WARN)
      end
    end,
  },
}
