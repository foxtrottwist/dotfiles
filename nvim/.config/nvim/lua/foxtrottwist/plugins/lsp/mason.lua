return {
  "williamboman/mason.nvim",
  dependencies = { "williamboman/mason-lspconfig.nvim" },
  config = function()
    -- import mason plugin safely
    local mason = require("mason")

    -- import mason-lspconfig plugin safely
    local mason_lspconfig = require("mason-lspconfig")

    -- enable mason
    mason.setup()

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "cssls",
        "emmet_ls",
        "gopls",
        "graphql",
        "html",
        "intelephense",
        "lua_ls",
        "phpactor",
        "pyright",
        "ruff",
        "rust_analyzer",
        "tailwindcss",
        "ts_ls",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = false, -- prevent duplicate LSP client instances
    })
  end,
}
