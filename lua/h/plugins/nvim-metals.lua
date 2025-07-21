return {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt", "java" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local metals_config = require("metals").bare_config()

    metals_config.settings = {
      showImplicitArguments = true,
      showInferredType = true,
    }

    metals_config.capabilities = vim.lsp.protocol.make_client_capabilities()

    metals_config.init_options = { statusBarProvider = "off", }

    -- metals_config.on_attach = function(_, bufnr)
    --   require("metals").setup_dap()
    --   -- Filter out noisy "Indexing complete!" LSP info messages
    --   vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
    --     local client = vim.lsp.get_client_by_id(ctx.client_id)
    --     if result.type <= vim.lsp.protocol.MessageType.Warning then
    --       vim.notify(result.message, vim.lsp.protocol.MessageType[result.type], {
    --         title = "LSP | " .. client.name,
    --       })
    --     end
    --   end
    --
    --   -- Keymap: Organize Imports
    --   vim.keymap.set(
    --     "n",
    --     "<leader>oi",
    --     function()
    --       vim.lsp.buf.execute_command({ command = "metals.organize-imports" })
    --     end,
    --     { buffer = bufnr, desc = "Organize Imports (Metals)" }
    --   )
    -- end

    metals_config.on_attach = function(client, bufnr)
      -- This is needed for the nvim-dap integration to work correctly
      require("metals").setup_dap()

      local map = vim.keymap.set
      local opts = { buffer = bufnr, noremap = true, silent = true }

      -- Your LSP keymaps (Go to Definition, Hover, etc.)
      map("n", "gd", vim.lsp.buf.definition, opts)
      map("n", "K", vim.lsp.buf.hover, opts)
      map("n", "gi", vim.lsp.buf.implementation, opts)
      map("n", "gr", vim.lsp.buf.references, opts)
      map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      map("n", "<leader>rn", vim.lsp.buf.rename, opts)
      map("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)

      -- Metals-specific command for organizing imports
      map("n", "<leader>oi", function()
        vim.lsp.buf.execute_command({ command = "metals.organize-imports" })
      end, { buffer = bufnr, desc = "Organize Imports (Metals)" })
    end

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt", "java" },
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
    -- metals_config.settings = {
    --   showImplicitArguments = true,
    --   showInferredType = true,
    -- }

    -- Simply initialize the server. No autocmd needed.
    -- require("metals").initialize_or_attach(metals_config)
  end,
}
