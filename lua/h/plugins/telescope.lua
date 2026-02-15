return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  -- Define all keys here so lazy-loading actually works
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string" },
    { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
  },
  -- branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })
  end,
}
