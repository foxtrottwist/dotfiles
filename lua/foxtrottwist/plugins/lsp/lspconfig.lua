return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    {
      "smjonas/inc-rename.nvim",
      config = true,
    },
    { -- Useful status updates for LSP
      "j-hui/fidget.nvim",
      opts = {
        window = {
          blend = 0,
        },
      },
    },
  },

  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local on_attach = require("foxtrottwist.plugins.lsp.utils.on_attach")

    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["emmet_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss" },
    })

    lspconfig.gleam.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["gopls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        gopls = {
          gofumpt = true,
        },
        flags = {
          debounce_text_changes = 150,
        },
      },
    })

    lspconfig["graphql"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
    })

    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure lua server (with special settings)
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = { -- custom settings for lua
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    lspconfig["pyright"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
            typeCheckingMode = "basic",
          }
        }
      }
    })

    lspconfig["sourcekit"].setup({
      capabilities = capabilities,
      cmd = { "sourcekit-lsp" },
      on_attach = on_attach,
      filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
    })

    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = {
        "rustup",
        "run",
        "stable",
        "rust-analyzer",
      },
    })

    lspconfig["tailwindcss"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["ts_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- PHP Language Servers
    lspconfig["intelephense"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        intelephense = {
          telemetry = {
            enabled = false,
          },
          files = {
            maxSize = 1000000,
          },
        },
      },
    })

    lspconfig["phpactor"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = function(fname)
        return lspconfig.util.root_pattern("composer.json", ".git")(fname) or lspconfig.util.path.dirname(fname)
      end,
      init_options = {
        ["language_server_phpstan.enabled"] = false,
        ["language_server_psalm.enabled"] = false,
      },
    })
  end,
}
