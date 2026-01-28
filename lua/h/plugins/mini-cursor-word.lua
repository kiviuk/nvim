return {
  "echasnovski/mini.cursorword",
  version = "*", -- or false for latest
  -- Optional: load only on certain events
  event = "VeryLazy",
  config = function()
    require('mini.cursorword').setup({
      -- Delay (in ms) between moving cursor and highlight appearing
      delay = 120, -- Use your preferred delay; default is 100
    })

    -- Optional: Change highlight style for matched words
    vim.api.nvim_set_hl(0, "MiniCursorword",        { underline = true, bold = true })
    vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { underline = false, bold = true })

    -- Optional: Disable in certain filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "TelescopePrompt", "NvimTree" },
      callback = function()
        vim.b.minicursorword_disable = true
      end,
    })
  end,
}
