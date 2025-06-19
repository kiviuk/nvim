return {
  "mobe/bannarizer.nvim",

  dir = vim.fn.stdpath("config") .. "/lua/h/mobe/bannarizer",

  cmd = { "Bannarize", "BannarizerRepeat" },

  keys = {
    {
      "<leader>b",
      ":Bannarize<CR>",
      mode = "n",
      desc = "Bannarize current line",
    },
    {
      "<leader>b",
      ":'<,'>Bannarize<CR>",
      mode = "v",
      desc = "Bannarize selection",
    },
    {
      "<leader>B",
      function()
        require("bannarizer").prompt_and_bannarize()
      end,
      mode = { "n", "v" },
      desc = "Bannarize with width prompt",
    },
  },

  config = function()
    -- Create :Bannarize command (accepts range and optional width argument)
    vim.api.nvim_create_user_command("Bannarize", function(opts)
      require("bannarizer").bannarize_range(opts)
    end, {
      range = true,
      nargs = "?",
    })

    -- Create repeat command to be used by repeat#set
    vim.api.nvim_create_user_command("BannarizerRepeat", function()
      require("bannarizer").repeat_last()
    end, {})
  end,
}
