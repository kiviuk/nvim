vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit i mode with jk" })
keymap.set("n", "<leader>.", ":nohl<CR>", { desc = "Clear search highlights" })

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

-- New Terminal
keymap.set("n", "<leader>t", function()
  vim.cmd("tabnew")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Open terminal in full window/buffer (insert mode)" })

-- Horizontal Terminal
keymap.set("n", "<leader>tv", function()
  vim.cmd("vsplit")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Open terminal in horizontal split (insert mode)" })

-- Vertical Terminal
keymap.set("n", "<leader>th", function()
  vim.cmd("split")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Open terminal in vertical split (insert mode)" })

-- To switch to adjacent windows (e.g., editor pane next to terminal split)
-- Assuming common layout: [Editor | Terminal]
vim.api.nvim_set_keymap(
  "t",
  "<C-h>",
  [[<C-\><C-n><C-w>h]],
  { noremap = true, silent = true, desc = "Switch to left window from terminal" }
)
vim.api.nvim_set_keymap(
  "t",
  "<C-l>",
  [[<C-\><C-n><C-w>l]],
  { noremap = true, silent = true, desc = "Switch to right window from terminal" }
)

-- To switch between tabs (e.g., if terminal is in its own tab)
vim.api.nvim_set_keymap(
  "t",
  "<C-Left>",
  [[<C-\><C-n>:tabprevious<CR>]],
  { noremap = true, silent = true, desc = "Switch to previous tab from terminal" }
)
vim.api.nvim_set_keymap(
  "t",
  "<C-Right>",
  [[<C-\><C-n>:tabnext<CR>]],
  { noremap = true, silent = true, desc = "Switch to next tab from terminal" }
)

-- Map <Esc><Esc> to exit terminal mode *and* close the window
-- vim.api.nvim_set_keymap("t", "<Esc><Esc>", [[<C-\><C-n>:close<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<Esc><Esc>", [[<C-\><C-n>gt]], { noremap = true, silent = true })

-- Quickly close a terminal window if it's not the last one
-- (Note: <leader>sx already closes current split, which works for terminals too)
keymap.set("n", "<leader>tc", "<cmd>close<CR>", { desc = "Close terminal split" })

-- Close Neovim (force quit)
keymap.set("n", "<leader>qq", ":qa!<CR>", { desc = "Force quit all" })

-- keymap.set({ "n", "x" }, "<S-Up>", "gk", { desc = "Move/Extend selection up" })
-- keymap.set({ "n", "x" }, "<S-Down>", "gj", { desc = "Move/Extend selection down" })

-- In Normal mode: Pressing Shift+Arrow enters Visual Line mode and selects the current line.
keymap.set("n", "<S-Up>", "V", { desc = "Start visual line selection (Up)" })
keymap.set("n", "<S-Down>", "V", { desc = "Start visual line selection (Down)" })

-- In Visual mode: Pressing Shift+Arrow just moves the cursor, extending the selection.
keymap.set("x", "<S-Up>", "k", { desc = "Extend visual selection up" })
keymap.set("x", "<S-Down>", "j", { desc = "Extend visual selection down" })

-- TMUX
keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "window left" })
keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "window right" })
keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "window down" })
keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "window up" })

-- Save all and quit
keymap.set("n", "<leader>qs", function()
  -- 1. Save the session first (if available)
  local success, _ = pcall(function()
    vim.cmd("SessionSave")
  end)

  -- Kill all terminal buffers cleanly
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buftype == "terminal" then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end

  -- 2. Save all buffers and quit
  vim.cmd("xa") -- Equivalent to :wqa (write all changed buffers and quit)
end, { desc = "Save session + all files and quit" })

-- Mark current file
keymap.set("n", "<leader>ha", function()
  require("harpoon.mark").add_file()
end, { desc = "Harpoon current file" })
-- Toggle Harpoon menu
keymap.set("n", "<leader>hm", function()
  require("harpoon.ui").toggle_quick_menu()
end, { desc = "Toggle Harpoon menu" })
-- Navigate to marked files
keymap.set("n", "<leader>hn", function()
  require("harpoon.ui").nav_next()
end, { desc = "Harpoon to next file" })
keymap.set("n", "<leader>hy", function()
  require("harpoon.ui").nav_prev()
end, { desc = "Harpoon to previous file" })

keymap.set("n", "gd", function()
  require("telescope.builtin").lsp_definitions()
end, { noremap = true, silent = true, desc = "Go to definition (LSP)" })

keymap.set("n", "<leader>u", function()
  require("telescope.builtin").lsp_references()
end, { noremap = true, silent = true, desc = "Find all references (LSP)" })

vim.keymap.set(
  "v",
  "<S-C-Down>",
  ":m '>+1<CR>gv=gv",
  { noremap = true, silent = true, desc = "moves lines down in visual selection" }
)
vim.keymap.set(
  "v",
  "<S-C-Up>",
  ":m '<-2<CR>gv=gv",
  { noremap = true, silent = true, desc = "moves lines up in visual selection" }
)

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
