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

            vim.wo.cursorline = true
            vim.wo.cursorcolumn = true

            -- Erase with q, w, a, y
            -- vim.keymap.set("n", "q", "r h", { buffer = true, noremap = true, silent = true, desc = "continuously erase left" })
            -- vim.keymap.set("n", "w", "r l", { buffer = true, noremap = true, silent = true, desc = "continuously erase right" })
            -- vim.keymap.set("n", "a", "r k", { buffer = true, noremap = true, silent = true, desc = "continuously erase up" })
            -- vim.keymap.set("n", "y", "r j", { buffer = true, noremap = true, silent = true, desc = "continuously erase down" })
            --
            -- Erase left
            vim.keymap.set("n", "q", function()
              vim.cmd('normal! r ')
              vim.cmd('normal! h')
            end, { buffer = true, noremap = true, silent = true, desc = "continuously erase left" })

            -- Erase right
            vim.keymap.set("n", "w", function()
              vim.cmd('normal! r ')
              vim.cmd('normal! l')
            end, { buffer = true, noremap = true, silent = true, desc = "continuously erase right" })

            -- Erase up
            vim.keymap.set("n", "a", function()
              vim.cmd('normal! r ')
              vim.cmd('normal! k')
            end, { buffer = true, noremap = true, silent = true, desc = "continuously erase up" })

            -- Erase down
            vim.keymap.set("n", "y", function()
              vim.cmd('normal! r ')
              vim.cmd('normal! j')
            end, { buffer = true, noremap = true, silent = true, desc = "continuously erase down" })

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
            vim.wo.cursorline = false
            vim.wo.cursorcolumn = false

            vim.keymap.del("n", "J", { buffer = true })
            vim.keymap.del("n", "K", { buffer = true })
            vim.keymap.del("n", "L", { buffer = true })
            vim.keymap.del("n", "H", { buffer = true })
            vim.keymap.del("v", "f", { buffer = true })

            vim.keymap.del("n", "q", { buffer = true })
            vim.keymap.del("n", "w", { buffer = true })
            vim.keymap.del("n", "a", { buffer = true })
            vim.keymap.del("n", "y", { buffer = true })

            vim.b.venn_enabled = nil
          end

        end,
        noremap = true,
        desc = "Toggle [V]enn diagramming mode",
      },
    },
  },
}
