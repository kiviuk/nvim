return {
  "SleepySwords/change-function.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("change-function").setup({})

    vim.keymap.set("n", "<leader>crl", function()
      require("change-function").change_function()
    end, { desc = "Change function arguments" })

    vim.keymap.set("n", "<leader>crq", function()
      require("change-function").change_function_via_qf()
    end, { desc = "Change function arguments (quickfix)" })
  end,
}
