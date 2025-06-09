return {
  -- Mason Core: Handles the UI and installation backend
  {
    "williamboman/mason.nvim",
    cmd = "Mason", -- Load Mason only when you run :Mason
    -- You can use 'opts' for simple table-based configuration
    -- or 'config' for function-based setup. 'opts' is often cleaner for simple cases.
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason LSP Config: Bridges Mason with nvim-lspconfig
  -- This should load when you actually open files that need LSPs.
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim", -- Needs mason to know what's installed
      "neovim/nvim-lspconfig", -- It will configure servers for nvim-lspconfig
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          -- Add other LSPs you always want installed here
          -- e.g., "pyright", "tsserver", "gopls", "rust_analyzer"
        },
        -- This is crucial: it tells mason-lspconfig how to setup servers.
        -- The 'handlers' section tells mason-lspconfig how to call `lspconfig.SERVER.setup{}`
        handlers = {
          -- Default handler: Sets up LSP with default capabilities.
          -- You should ideally pass your CMP capabilities here.
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(), -- If using nvim-cmp
            })
          end,

          -- Example for lua_ls with specific settings
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(), -- If using nvim-cmp
              settings = {
                Lua = {
                  diagnostics = { globals = { "vim" } },
                  workspace = { checkThirdParty = false }, -- If you use EmmyLua-like annotations
                  telemetry = { enable = false },
                },
              },
            })
          end,

          -- CUSTOM HANDLER FOR PYRIGHT
          ["pyright"] = function()
            require("lspconfig").pyright.setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
              -- IMPORTANT: Pyright's settings for virtual environments
              settings = {
                python = {
                  analysis = {
                    -- This is the most crucial part for telling Pyright where to find your Python interpreter.
                    -- It will respect the VIRTUAL_ENV environment variable, but you can also be explicit.
                    -- `autoSearchPaths = true` is generally good for Pyright to find standard locations.
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    indexing = true,
                    -- `extraPaths` can be useful if you have specific modules not in your standard PYTHONPATH
                    -- that are relative to your project root. E.g., if your source is in `src/`
                    -- extraPaths = { "src" },
                  },
                },
                positionEncoding = "utf-8",
              },
            })
          end,

          -- Add more custom handlers for other LSPs if they need special setup
          -- e.g. ["pyright"] = function() require("lspconfig").pyright.setup({...}) end
        },
      })
    end,
  },

  -- nvim-lspconfig: The actual LSP client functionality
  -- This also loads when you open files.
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      -- Global LSP settings, keymaps, and diagnostic configurations go here.
      -- This function runs when nvim-lspconfig is loaded.
      -- Actual server `setup` calls are handled by mason-lspconfig's handlers.

      -- Example: Setup keymaps on LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- vim.lsp.set_log_level("debug")

          -- Buffer local mappings.
          local opts = { buffer = ev.buf, noremap = true, silent = true }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)

          -- Diagnostics
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
        end,
      })
    end,
  },

  -- Mason Tool Installer: For formatters, linters etc.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "ruff", -- python formatter / linter
        "pylint", -- python linter (ruff can often replace this)
        "eslint_d", -- js linter
        -- Add other linters/formatters
      },
      -- auto_update = true, -- Optional: automatically update tools
      -- run_on_start = true, -- Optional: run ensure_installed on Neovim start (can slow down startup if many tools)
      -- If false, you might need to run a command to install them initially.
      -- If using `event = "VeryLazy"`, `run_on_start = true` is common.
    },
  },
}
