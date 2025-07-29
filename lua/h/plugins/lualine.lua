return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")
    local function get_file_size()
      local filepath = vim.api.nvim_buf_get_name(0)
      if filepath == "" then return "" end -- No file name associated with the buffer

      -- Use pcall to gracefully handle errors (e.g., file not saved yet)
      local ok, stats = pcall(vim.loop.fs_stat, filepath)
      if not ok or not stats then return "" end

      local size = stats.size
      if size == 0 then return "" end

      -- Format the size into a human-readable string (B, K, M, G, T)
      local units = { 'B', 'K', 'M', 'G', 'T' }
      local i = 1
      while size >= 1024 and i < #units do
        size = size / 1024
        i = i + 1
      end

      -- Return the formatted string with a floppy disk icon
      -- It shows decimals for KB and higher, but not for Bytes.
      local format_str = (i == 1) and "%.0f%s" or "%.1f%s"
      return "󰋊 " .. string.format(format_str, size, units[i])
    end
    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }
    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = my_lualine_theme,
      },
      sections = {
        lualine_x = {
          -- { get_file_size }, -- Component for file size
          {
            function()
              return " " .. vim.fn.line('$') -- Component for total lines
            end
          },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
