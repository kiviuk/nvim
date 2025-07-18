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

    metals_config.on_attach = function(client, bufnr)
        vim.keymap.set(
          "n",
          "<leader>oi", -- "oi" for "organize imports"
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
