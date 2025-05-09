return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
      metals_config.on_attach = function(client, bufnr)
        vim.keymap.set("n", "K", vim.lsp.buf.hover)
        -- Helper for setting buffer-local keymaps
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        -- Your core keymaps
        map("K", vim.lsp.buf.hover, "Hover")
        map("gd", vim.lsp.buf.definition, "Go To Definition")
        map("gi", vim.lsp.buf.implementation, "Go To Implementation")
        map("gr", vim.lsp.buf.references, "Go To References")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
        map("<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, "Format Code")
        map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
        map("<leader>e", vim.diagnostic.open_float, "Line Diagnostics")
        map("<leader>q", vim.diagnostic.setloclist, "Open Diagnostics List[48;37;185;999;1850t")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

        -- Workspace folder mappings (uncomment if needed)
        -- map("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
        -- map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
        -- map("<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Workspace Folders")

        -- You could add a notification that Metals attached:
        -- vim.notify("Metals LSP attached to buffer " .. bufnr, vim.log.levels.INFO)
      end

      metals_config.settings = {
        showImplicitArguments = true,
        showInferredType = true,
        -- Add other settings from :h metals-settings if desired
      }

      return metals_config
    end,
    config = function(metals, metals_config)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" }, -- Only these filetypes!
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
      })
    end,
  },
}
