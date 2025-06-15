return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup({
        ensure_installed = {
          "basedpyright", -- Python LSP server
          "ruff", -- Ruff linter/formatter (and its LSP server)
          "stylua", -- Lua formatter
          -- Only tools explicitly needed for your chosen languages.
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      local util = lspconfig.util
      local mason_lspconfig = require("mason-lspconfig")

      -- Define server-specific settings
      local servers = {
        basedpyright = {
          root_dir = util.root_pattern("pyproject.toml", ".git"),
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff = {
          root_dir = util.root_pattern("pyproject.toml", ".git"),
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              completion = { callSnippet = "Replace" },
            },
          },
        },
      }

      -- Get default client capabilities and merge with cmp_nvim_lsp's required capabilities
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Define a common on_attach function
      local on_attach = function(client, bufnr) end

      -- Setup mason-lspconfig to automatically configure LSP servers
      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local server_config = servers[server_name] or {}
            lspconfig[server_name].setup(vim.tbl_deep_extend("force", server_config, {
              -- Explicitly set capabilities and on_attach for each server via mason-lspconfig
              capabilities = capabilities,
              on_attach = on_attach,
            }))
          end,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    -- Load this plugin only for filetypes where you expect LSP functionality.
    ft = { "python", "lua", "java", "scala" },
    config = function()
      -- Define LSP keymaps (these are general and apply to any active LSP client)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

      -- Diagnostic keymaps (these are general and apply to any diagnostics)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostic List" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "BufWritePost", -- Trigger linting on save
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" }, -- Use ruff for Python linting
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          require("lint").try_lint()
        end,
      })
      vim.keymap.set("n", "<leader>l", function()
        require("lint").try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
  {
    "stevearc/conform.nvim",
    lazy = false, -- Load early for format-on-save functionality
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" }, -- Use ruff_format for Python formatting
        lua = { "stylua" }, -- Use stylua for Lua formatting
        yaml = { "prettier" },
      },
      format_on_save = {
        lsp_format = false, -- IMPORTANT: Prevent conflicts with LSP servers also offering formatting
        async = true,
        timeout_ms = 1000,
      },
    },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format({ async = true, lsp_format = false })
        end,
        mode = { "n", "v" },
        desc = "Format buffer/range (Conform)",
      },
    },
  },
}
