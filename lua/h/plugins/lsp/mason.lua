-- Effortless Autocomplete & LSP Setup in Neovim for Web Development (Tutorial) – EP 2
-- https://youtu.be/ScIjavsi7LE?t=325
return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      servers = {
        bashls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "basedpyright",
          "ruff",
          "rust_analyzer",
          "bashls",
        }
      })

      vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = false,
        underline = true,
      })

      for server, config in pairs(opts.servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end
  },
}
