local function strip_file_uri(pattern)
  if type(pattern) == "string" and pattern:match("^file://") then
    return pattern:gsub("^file://", "")
  end
  return pattern
end

local orig_to_lpeg = vim.glob.to_lpeg
vim.glob.to_lpeg = function(pattern)
  return orig_to_lpeg(strip_file_uri(pattern))
end

return {
  "scalameta/nvim-metals",
  ft = { "scala", "sbt", "java" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local metals_config = require("metals").bare_config()

    metals_config.settings = {
      showImplicitArguments = true,
      showInferredType = true,
      superMethodLensesEnabled = true,
      enableSemanticHighlighting = true,
      enableStripMarginOnTypeFormatting = true,
    }

    metals_config.capabilities = vim.lsp.protocol.make_client_capabilities()

    metals_config.init_options = { statusBarProvider = "off", }

    metals_config.on_attach = function(client, bufnr)
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

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
  end,
}
