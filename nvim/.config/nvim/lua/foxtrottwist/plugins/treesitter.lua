return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- enable syntax highlighting
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
        -- textobjects configuration
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment region" },
              ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment region" },
              ["a:"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/field region" },
              ["i:"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/field region" },
              ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional region" },
              ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional region" },
              ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop region" },
              ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop region" },
              ["ab"] = { query = "@block.outer", desc = "Select outer part of a block region" },
              ["ib"] = { query = "@block.inner", desc = "Select inner part of a block region" },
              ["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
              ["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },
              ["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>on"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>op"] = "@parameter.inner",
            },
          },
        },
      })

    end,
  },
}
