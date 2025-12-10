return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    {
      "smjonas/inc-rename.nvim",
      config = true,
    },
    {
      "j-hui/fidget.nvim",
      opts = {
        notification = {
          window = {
            winblend = 0,
          },
        },
      },
    },
  },

  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Configure diagnostic signs
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    -- Global LSP configuration (applies to all servers)
    vim.lsp.config("*", {
      capabilities = cmp_nvim_lsp.default_capabilities(),
    })

    -- LspAttach autocmd for keymaps (replaces on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local bufnr = ev.buf

        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, { noremap = true, silent = true, buffer = bufnr, desc = desc })
        end

        nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
        nmap("gd", "<cmd>Glance definitions<CR>", "Peek definition and edit in window")
        nmap("gi", vim.lsp.buf.implementation, "Go to implementation")
        -- K is handled by hover.nvim for enhanced hover with multiple providers
        nmap("<leader>ca", vim.lsp.buf.code_action, "See available code actions")
        nmap("<leader>fr", "<cmd>Telescope lsp_references<CR>", "Show definition references")
        nmap("<leader>ld", vim.diagnostic.open_float, "show diagnostics for line")
        nmap("<leader>d", vim.diagnostic.open_float, "show diagnostics for cursor")
        nmap("[d", vim.diagnostic.goto_prev, "jump to previous diagnostic in buffer")
        nmap("]d", vim.diagnostic.goto_next, "jump to next diagnostic in buffer")
        nmap("<leader>rn", ":IncRename ", "Smart rename")
        nmap("<leader>sd", "<cmd>Telescope lsp_document_symbols<CR>", "Show current document symbols")
        nmap("<leader>sw", "<cmd>Telescope lsp_workspace_symbols<CR>", "Show workspace symbols")
      end,
    })

    -- Enable all configured LSP servers
    vim.lsp.enable({
      "cssls",
      "emmet_ls",
      "gleam",
      "gopls",
      "graphql",
      "html",
      "intelephense",
      "lua_ls",
      "phpactor",
      "pyright",
      "rust_analyzer",
      "sourcekit",
      "tailwindcss",
      "ts_ls",
    })
  end,
}
