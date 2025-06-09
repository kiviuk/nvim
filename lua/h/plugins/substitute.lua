return {
  "gbprod/substitute.nvim",
  event = { "VeryLazy" },
  config = function()
    local substitute = require("substitute")
    local exchange = require("substitute.exchange")

    substitute.setup()

    -- set keymaps
    local keymap = vim.keymap

    -- Substitute mappings
    keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
    keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
    keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
    keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })

    -- Exchange mappings
    keymap.set("n", "sx", exchange.operator, { desc = "Exchange text with motion" })
    keymap.set("n", "sxx", exchange.line, { desc = "Exchange current line" })
    keymap.set("x", "X", exchange.visual, { desc = "Exchange visual selection" })
    keymap.set("n", "sxc", exchange.cancel, { desc = "Cancel exchange operation" })
  end,
}
