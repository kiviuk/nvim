return {
  -- Enable spell checking for text-like filetypes
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "text", "gitcommit" },
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en"
        end,
      })
    end,
  },
}
