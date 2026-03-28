return {
  "williamboman/mason.nvim",
  event = { "BufReadPost" },
  ft = { "python", "rust", "lua", "bash", "scala", "sbt", "java" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
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
      virtual_text = false,
      virtual_lines = false,
      underline = false,
    })

    vim.lsp.config.lua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          completion = { callSnippet = "Replace" },
        },
      },
    }
    vim.lsp.config.bashls = {}
    vim.lsp.config.basedpyright = {}
    vim.lsp.config.ruff = {}
    vim.lsp.config.rust_analyzer = {}

    vim.lsp.enable("lua_ls")
    vim.lsp.enable("bashls")
    vim.lsp.enable("basedpyright")
    vim.lsp.enable("ruff")
    vim.lsp.enable("rust_analyzer")
  end
}

--
-- return {
--   "williamboman/mason.nvim",
--   cmd = "Mason",
--   dependencies = {
--     "williamboman/mason-lspconfig.nvim",
--     "neovim/nvim-lspconfig",
--   },
--   opts = 
--     servers = {
--       bashls = {},
--       lua_ls = {
--         settings = {
--           Lua = {
--             diagnostics = {
--               globals = { "vim" },
--             },
--           },
--         },
--       },
--       basedpyright = {},
--       ruff = {},
--       rust_analyzer = {},
--     },
--   },
--   config = function(_, opts)
--     require("mason").setup()
--
--     require("mason-lspconfig").setup({
--       ensure_installed = {
--         "lua_ls",
--         "basedpyright",
--         "ruff",
--         "rust_analyzer",
--         "bashls",
--       }
--     })
--
--     vim.diagnostic.config({
--       virtual_text = true,
--       virtual_lines = false,
--       underline = true,
--     })
--
--     for server, config in pairs(opts.servers) do
--       require("lspconfig")[server].setup(config)
--     end
--   end
-- }

-- -- return {
-- --   {
-- --     "williamboman/mason.nvim",
-- --     lazy = false, -- Important: don't make it lazy-loaded
-- --     priority = 1000, -- High priority to ensure it loads first
-- --     config = function()
-- --       require("mason").setup()
-- --     end
-- --   }
-- -- }
-- --
-- return {
--   {
--     "williamboman/mason.nvim",
--     cmd = "Mason",
--     keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
--     build = ":MasonUpdate",
--     opts = {
--       ui = {
--         icons = {
--           package_installed = "✓",
--           package_pending = "➜",
--           package_uninstalled = "✗",
--         },
--       },
--     },
--   },
--   {
--     "williamboman/mason-lspconfig.nvim",
--     dependencies = {
--       "williamboman/mason.nvim",
--       "neovim/nvim-lspconfig",
--     },
--   },
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       "williamboman/mason.nvim",
--       "williamboman/mason-lspconfig.nvim",
--     },
--     config = function()
--       require("mason").setup()
--       require("mason-lspconfig").setup({
--         ensure_installed = {
--           "lua_ls",
--           "basedpyright",
--           "ruff",
--           "rust_analyzer",
--           "bashls",
--         }
--       })
--
--       vim.diagnostic.config({
--         virtual_text = true,
--         virtual_lines = false,
--         underline = true,
--       })
--
--       -- LSP server configuration
--       local lspconfig = require("lspconfig")
--
--       lspconfig.lua_ls.setup({
--         settings = {
--           Lua = {
--             diagnostics = {
--               globals = { "vim" },
--             },
--           },
--         },
--       })
--
--       lspconfig.bashls.setup({})
--       lspconfig.basedpyright.setup({})
--       lspconfig.ruff.setup({})
--       lspconfig.rust_analyzer.setup({})
--     end,
--   },
-- }
