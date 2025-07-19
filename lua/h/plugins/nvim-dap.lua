return {
  "mfussenegger/nvim-dap",
  event = { "VeryLazy" },
  -- LAZY-LOADING TRIGGERS: Load on command, keymap, or when a dependency needs it.
  cmd = {
    "DapContinue",
    "DapClose",
    "DapStepOver",
    "DapStepInto",
    "DapStepOut",
    "DapToggleBreakpoint",
    "DapTerminate",
  },
  keys = {
    { "<leader>d" }, -- Any key starting with <leader>d will now load the plugin
  },
  dependencies = {
    -- UI for DAP - Now correctly lazy-loaded
    {
      "rcarriga/nvim-dap-ui",
      -- No event trigger here. It will be loaded on demand by the main dap config below.
      dependencies = { "nvim-neotest/nvim-nio" },
      -- The config for dapui can be minimal or empty, as we'll set it up from the main dap plugin.
      opts = {
        controls = { enabled = true },
      },
    },

    -- Other dependencies...
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
      config = function()
        require("mason-nvim-dap").setup({
          automatic_installation = true,
          handlers = {},
        })
      end,
    },
    { "theHamsta/nvim-dap-virtual-text", config = true },
    {
      "nvim-telescope/telescope-dap.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
        require("telescope").load_extension("dap")
      end,
    },
  },

  -- THIS IS THE MAIN CONFIGURATION BLOCK FOR THE DAP PLUGIN
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- *** THIS IS THE KEY CHANGE ***
    -- Setup listeners that will load and open dap-ui when a debug session starts.
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Keymaps for dapui. These will work because the main 'dap' plugin is loaded.
    vim.keymap.set("n", "<Leader>dut", dapui.toggle, { desc = "DAP UI Toggle" })
    vim.keymap.set("n", "<Leader>due", function()
      dapui.eval(nil, { enter = true })
    end, { desc = "DAP UI Eval Input" })
    vim.keymap.set("v", "<Leader>due", dapui.eval, { desc = "DAP UI Eval Visual" })

    -- Define how to launch or attach to Java/Scala applications
    dap.configurations.java = {
      {
        type = "java",
        request = "launch",
        name = "Launch Current File (Java)",
        mainClass = "",
        projectName = "",
      },
      {
        type = "java",
        request = "attach",
        name = "Attach to Remote JVM",
        hostName = "127.0.0.1",
        port = 5005,
      },
    }
    dap.configurations.scala = dap.configurations.java
  end,
}
