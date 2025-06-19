return {
  -- A name for your local plugin. Using a path-like name is a good convention.
  "mobe/bannarizer.nvim",

  -- This is the most important part for a local plugin.
  -- It tells lazy.nvim where to find the plugin's source code.
  dir = vim.fn.stdpath("config") .. "/lua/h/mobe/bannarizer.nvim",

  -- Lazy-load the plugin when the :Bannarize command is used.
  cmd = "Bannarize",

  -- Also lazy-load when these keys are pressed.
  -- This is the preferred LazyVim way to set up keymaps.
  keys = {
    {
      "<leader>b",
      ":.Bannarize<CR>",
      mode = "n",
      desc = "Bannarize Current Line",
    },
    {
      "<leader>b",
      ":'<,'>Bannarize<CR>",
      mode = "v",
      desc = "Bannarize Selection",
    },
  },

  -- The config function runs once after the plugin is loaded.
  -- This is the perfect place to set up commands.
  config = function()
    vim.api.nvim_create_user_command("Bannarize", function(opts)
      -- The require path 'bannarizer' maps to the 'lua/bannarizer/init.lua' file
      -- inside your plugin's directory.
      require("bannarizer").bannarize_range(opts)
    end, {
      range = true, -- Crucial: allows the command to accept a range like :., :'<,'>
    })
  end,
}
