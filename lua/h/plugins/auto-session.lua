return {
  "rmagatti/auto-session",
  event = "VimEnter",
  config = function()
    -- Try reducing sessionoptions
    vim.o.sessionoptions = table.concat({
      "buffers",
      "curdir",
      "folds",
      "tabpages",
      "winsize",
      "winpos",
      "localoptions",
    }, ",")

    local auto_session = require("auto-session")
    auto_session.setup({
      log_level = vim.log.levels.WARN,
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })
  end,
}
