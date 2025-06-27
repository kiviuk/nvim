return {
  "gbprod/substitute.nvim",
  event = { "VeryLazy" },
  enable = false,
  config = function()
    local substitute = require("substitute")
    local exchange = require("substitute.exchange")
    substitute.setup()

    -- Only set keymaps in normal, modifiable buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        if vim.bo.buftype == "" and vim.bo.modifiable then
          local keymap = vim.keymap

          -- Substitute mappings
          keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion", buffer = true })
          keymap.set("n", "ss", substitute.line, { desc = "Substitute line", buffer = true })
          keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line", buffer = true })
          keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode", buffer = true })

          -- Exchange mappings
          keymap.set("n", "sx", exchange.operator, { desc = "Exchange with motion", buffer = true })
          keymap.set("n", "sxx", exchange.line, { desc = "Exchange line", buffer = true })
          keymap.set("x", "X", exchange.visual, { desc = "Exchange visual", buffer = true })
          keymap.set("n", "sxc", exchange.cancel, { desc = "Cancel exchange", buffer = true })
        end
      end,
    })
  end,
}
