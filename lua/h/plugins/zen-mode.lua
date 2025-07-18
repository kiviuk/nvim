return {
  "folke/zen-mode.nvim",
  config = function()
    require("zen-mode").setup({
      window = { width = 140 }  -- set width as desired
    })
  end
}
