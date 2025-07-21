-- symbols-outline.nvim (Outline Sidebar)
return {
  "simrat39/symbols-outline.nvim",
  cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
  keys = {
    { "<leader>o", "<cmd>SymbolsOutline<CR>", desc = "Toggle Symbols Outline" }
  },
  config = function()
    require("symbols-outline").setup()
  end,
}
