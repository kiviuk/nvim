return {
  {
    "jbyuki/venn.nvim",
    -- The `keys` table will lazy-load the plugin when you press the keymap.
    keys = {
      {
        "<leader>v",
        function()
          -- This is the toggle function from your example.
          local venn_enabled = vim.inspect(vim.b.venn_enabled)
          if venn_enabled == "nil" then
            vim.b.venn_enabled = true
            vim.wo.virtualedit = "all"

            -- Setting buffer-local keymaps to draw lines and boxes.
            -- Added `noremap=true` and `silent=true` for consistency with best practices.
            vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { buffer = true, noremap = true, silent = true })
            vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { buffer = true, noremap = true, silent = true })
            vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { buffer = true, noremap = true, silent = true })
            vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { buffer = true, noremap = true, silent = true })
            vim.keymap.set("v", "f", ":VBox<CR>", { buffer = true, noremap = true, silent = true })
          else
            -- Disable the mode and remove the keymaps.
            vim.wo.virtualedit = ""
            vim.keymap.del("n", "J", { buffer = true })
            vim.keymap.del("n", "K", { buffer = true })
            vim.keymap.del("n", "L", { buffer = true })
            vim.keymap.del("n", "H", { buffer = true })
            vim.keymap.del("v", "f", { buffer = true })
            vim.b.venn_enabled = nil
          end
        end,
        noremap = true,
        desc = "Enable/Disable [V]enn diagramming mode",
      },
    },
  },
}
-- return {
--   {
--     "jbyuki/venn.nvim",
--     -- Optional: Load only for certain filetypes or commands
--     -- event = "VeryLazy",
--   },
-- }
--
-- -- File: ./lua/h/plugins/venn-vim.lua
--
