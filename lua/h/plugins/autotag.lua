return {
  "windwp/nvim-ts-autotag",
  event = "InsertEnter", -- Only load when typing
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
