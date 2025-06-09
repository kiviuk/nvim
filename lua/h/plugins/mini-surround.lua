return {
  "echasnovski/mini.surround",
  event = "VeryLazy",
  version = false, -- or '*', or you can specify a branch like 'stable'
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        replace = "gsr", -- Replace surrounding
        highlight = "gsh", -- Highlight surrounding
      },
    })
  end,
}
