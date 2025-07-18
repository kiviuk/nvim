return {
  "Exafunction/windsurf.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "saghen/blink.cmp",
  },

  config = function()
    require("codeium").setup({
      -- any specific config options here
      enable_cmp_source = false,
    })
  end,
}

