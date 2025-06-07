return {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt", "java" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
  },
  -- The config function now runs automatically for the correct filetypes
  config = function()
    -- Get the bare config and add our customizations
    local metals_config = require("metals").bare_config()
    metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

    metals_config.on_attach = function(client, bufnr)
      -- Helper for setting buffer-local keymaps
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end
      -- Your core keymaps
      map("K", vim.lsp.buf.hover, "Hover")
      map("gd", vim.lsp.buf.definition, "Go To Definition")
      -- ... etc
    end

    metals_config.settings = {
      showImplicitArguments = true,
      showInferredType = true,
    }

    -- Simply initialize the server. No autocmd needed.
    require("metals").initialize_or_attach(metals_config)
  end,
}
