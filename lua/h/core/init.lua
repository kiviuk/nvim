-- -- vim.g.python3_host_prog = "/Users/mobe/Projects/FieldData-Cloudification/venv/bin/python"
-- vim.g.loaded_perl_provider = 0
-- vim.g.loaded_ruby_provider = 0
-- vim.g.loaded_node_provider = 0
--
-- function _G.Toggle_venn()
--   local venn_enabled = vim.inspect(vim.b.venn_enabled)
--   if venn_enabled == "nil" then
--     vim.b.venn_enabled = true
--     vim.cmd([[setlocal ve=all]])
--     vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
--     vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
--     vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
--     vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
--     vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
--   else
--     vim.cmd([[setlocal ve=]])
--     vim.api.nvim_buf_del_keymap(0, "n", "J")
--     vim.api.nvim_buf_del_keymap(0, "n", "K")
--     vim.api.nvim_buf_del_keymap(0, "n", "L")
--     vim.api.nvim_buf_del_keymap(0, "n", "H")
--     vim.api.nvim_buf_del_keymap(0, "v", "f")
--     vim.b.venn_enabled = nil
--   end
-- end
--
-- vim.api.nvim_set_keymap("n", "<leader>v", ":lua Toggle_venn()<CR>", { noremap = true })

require("h.core.options")
require("h.core.keymaps")
