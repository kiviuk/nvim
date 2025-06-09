vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit i mode with jk" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- inc/dec numbers
keymap.set("n", "<leader>=", "<C-a>", { desc = "Inc numb" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Dec numb" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vert" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horiz" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Split window equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Save file
keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })

-- Navigate between tree explorer and editor
keymap.set("n", "<C-Left>", "<cmd>NvimTreeFocus<CR>", { desc = "Focus Explorer" })
keymap.set("n", "<C-Right>", "<cmd>wincmd p<CR>", { desc = "Focus Back to Buffer" })

-- Open a new terminal in a full window/buffer
keymap.set("n", "<leader>t", "<cmd>terminal<CR>", { desc = "Open terminal" })

-- Open a new terminal in a vertical split
keymap.set("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Open terminal (vertical split)" })

-- Open a new terminal in a horizontal split
keymap.set("n", "<leader>th", "<cmd>split | terminal<CR>", { desc = "Open terminal (horizontal split)" })

-- Quickly close a terminal window if it's not the last one
-- (Note: <leader>sx already closes current split, which works for terminals too)
keymap.set("n", "<leader>tc", "<cmd>close<CR>", { desc = "Close terminal split" })

-- Close Neovim (force quit)
keymap.set("n", "<leader>qq", ":qa!<CR>", { desc = "Force quit all" })

-- Save all and quit
keymap.set("n", "<leader>qs", function()
  -- 1. Save the session first (if available)
  local success, _ = pcall(function()
    vim.cmd("SessionSave")
  end)

  -- 2. Save all buffers and quit
  vim.cmd("xa") -- Equivalent to :wqa (write all changed buffers and quit)
end, { desc = "Save session + all files and quit" })

-- <leader>ä
keymap.set("n", "<leader>'", vim.diagnostic.open_float, { desc = "Show diagnostics in floating window" })

-- Save / recall last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
