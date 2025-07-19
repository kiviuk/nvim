return {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt", "java" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local metals_config = require("metals").bare_config()

    metals_config.capabilities = vim.lsp.protocol.make_client_capabilities()

    metals_config.init_options = {
      statusBarProvider = "off",
    }

    metals_config.on_attach = function(client, bufnr)
      -- Filter out noisy "Indexing complete!" LSP info messages
      vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if result.type <= vim.lsp.protocol.MessageType.Warning then
          vim.notify(result.message, vim.lsp.protocol.MessageType[result.type], {
            title = "LSP | " .. client.name,
          })
        end
      end

      -- Keymap: Organize Imports
      vim.keymap.set(
        "n",
        "<leader>oi",
        function()
          vim.lsp.buf.execute_command({ command = "metals.organize-imports" })
        end,
        { buffer = bufnr, desc = "Organize Imports (Metals)" }
      )
    end

    metals_config.settings = {
      showImplicitArguments = true,
      showInferredType = true,
    }

    -- Simply initialize the server. No autocmd needed.
    require("metals").initialize_or_attach(metals_config)
  end,
}
