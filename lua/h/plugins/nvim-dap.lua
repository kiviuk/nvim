return {
  -- The core DAP plugin
  "mfussenegger/nvim-dap",
  keys = {
    -- Stepping
    {
      "<Leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "DAP Continue",
    },
    {
      "<Leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "DAP Step Over",
    },
    {
      "<Leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "DAP Step Into",
    },
    {
      "<Leader>du",
      function()
        require("dap").step_out()
      end,
      desc = "DAP Step Out",
    }, -- Note UI toggle key below

    -- Breakpoints
    {
      "<Leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "DAP Toggle Breakpoint",
    },
    {
      "<Leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "DAP Set Conditional Breakpoint",
    },
    {
      "<Leader>dlp",
      function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end,
      desc = "DAP Set Log Point",
    },

    -- Session Management & REPL
    {
      "<Leader>dr",
      function()
        require("dap").repl.open()
      end,
      desc = "DAP Open REPL",
    },
    {
      "<Leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "DAP Run Last Config",
    },
    {
      "<Leader>dq",
      function()
        require("dap").terminate()
      end,
      desc = "DAP Terminate/Quit",
    },
    {
      "<Leader>dsc",
      function()
        require("dap").run_to_cursor()
      end,
      desc = "DAP Run To Cursor",
    },

    -- Add a key to select configuration (requires telescope-dap)
    {
      "<Leader>ds",
      function()
        -- Requires telescope-dap extension loaded
        require("telescope").extensions.dap.configurations({})
      end,
      { desc = "DAP Select Configuration" },
    },
  },
  dependencies = {
    -- UI for DAP
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
      config = function()
        local dapui = require("dapui")
        dapui.setup({
          -- Configure layouts, icons, etc. as desired
          -- Example layout tweak:
          -- layouts = { ... } see :h dapui-layouts
          controls = { enabled = true }, -- Show buttons for controls
        })

        local dap = require("dap")
        -- Auto open/close dap-ui
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end

        -- Keymaps for dapui (using <Leader>du[something] to avoid clash with step_out)
        vim.keymap.set("n", "<Leader>dut", function()
          dapui.toggle()
        end, { desc = "DAP UI Toggle" })
        vim.keymap.set("n", "<Leader>due", function()
          dapui.eval(nil, { enter = true })
        end, { desc = "DAP UI Eval Input" })
        vim.keymap.set("v", "<Leader>due", function()
          dapui.eval()
        end, { desc = "DAP UI Eval Visual" })
      end,
    },

    -- Installs debug adapters via Mason
    {
      "williamboman/mason.nvim",
      -- Ensure it runs before mason-nvim-dap
      -- config = true or your custom mason config
    },

    -- Integrates Mason-installed adapters with nvim-dap
    {
      "jay-babu/mason-nvim-dap.nvim",
      -- Ensure mason runs first
      dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
      -- This handler function will automatically configure adapters found by Mason
      -- including java-debug-adapter if it's installed via Mason.
      handlers = {
        function(config)
          -- Default setup for all installed adapters
          require("mason-nvim-dap").default_setup(config)
        end,
        -- You could add specific handlers per language if needed, e.g.:
        -- java = function(config) ... end,
      },
      -- Ensure this setup runs *after* mason.nvim loads
      -- lazy.nvim handles this via dependencies typically.
      -- If using packer, you might use 'after = "mason.nvim"'
    },

    -- Optional: Virtual text for inline variable display
    {
      "theHamsta/nvim-dap-virtual-text",
      config = true,
    },

    -- Optional: Telescope integration for selecting configurations
    {
      "nvim-telescope/telescope-dap.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
        require("telescope").load_extension("dap")
      end,
    },

    -- Include nvim-jdtls if you use it for Java LSP & DAP integration
    -- {
    --   "mfussenegger/nvim-jdtls",
    --   -- Ensure your nvim-jdtls config potentially sets up DAP integration:
    --   -- See nvim-jdtls documentation for DAP setup options. It might offer
    --   -- an alternative way to configure the adapter and configurations.
    -- },

    -- Include nvim-metals if you use it for Scala LSP & DAP integration
    -- {
    --   "scalameta/nvim-metals",
    --   dependencies = { "nvim-lua/plenary.nvim" },
    --   config = function()
    --     -- Your nvim-metals setup. Metals has its own DAP integration.
    --     -- You might configure DAP via Metals settings *instead of* or
    --     -- *in addition to* the manual dap.configurations below.
    --     -- Check nvim-metals documentation (:h metals-debug-adapter)
    --   end
    -- }
  },
  config = function()
    local dap = require("dap")

    -- === Java / Scala Configurations ===
    -- NOTE: If using mason-nvim-dap (recommended above), the adapter itself
    -- should be configured automatically if 'java-debug-adapter' is installed via Mason.
    -- You mainly need to define the launch/attach configurations below.

    -- If NOT using mason-nvim-dap, you would manually configure the adapter path:
    --[[
    local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
    dap.adapters.java = {
      type = 'executable',
      -- Adjust command/args based on your java-debug-adapter installation
      -- This is a typical path if installed via Mason:
      command = mason_path .. 'packages/java-debug-adapter/extension/server/bin/java-debug-adapter',
      -- Or if launching via a script provided by java-debug-adapter or nvim-jdtls:
      -- command = '/path/to/your/java-debug-launcher-script',
      args = {} -- Add specific args if needed
    }
    ]]
    --

    -- Define how to launch or attach to Java/Scala applications
    -- These configurations will be used by the adapter configured above (manually or via mason-nvim-dap)
    dap.configurations.java = {
      {
        type = "java", -- Must match the adapter name
        request = "launch",
        name = "Launch Current File (Java)",
        -- Assumes a standard Java project structure where the compiled class is found
        -- May need adjustment based on build tools (Maven, Gradle)
        mainClass = "", -- Often needs to be set, or determined dynamically
        projectName = "", -- Useful for multi-module projects
        vmArgs = {}, -- e.g., vmArgs = { "-Xmx512m" },
        args = {}, -- Program arguments
        -- Requires nvim-jdtls usually to resolve classpath etc. correctly
        -- Or you might need to specify classpath manually/via build tool integration
      },
      {
        type = "java", -- Must match the adapter name
        request = "attach",
        name = "Attach to Remote JVM",
        hostName = "127.0.0.1", -- Or the remote host
        port = 5005, -- Standard Java debug port, ensure the JVM was started with debug agent
      },
      -- Add more configurations for specific frameworks (Spring Boot, etc.)
      -- or build tools (Maven/Gradle tasks) if needed.
    }

    -- Scala often uses the same Java Debug Adapter and configurations.
    -- You might create specific Scala configurations if needed, potentially invoking SBT tasks.
    -- If using nvim-metals, it often provides its own DAP configurations.
    dap.configurations.scala = dap.configurations.java -- Reuse Java configs by default
  end,
}
