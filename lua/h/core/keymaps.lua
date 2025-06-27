-- https://github.com/Sin-cy/dotfiles/blob/main/nvim/.config/nvim/lua/sethy/core/keymaps.lua
-- The Ultimate Neovim Setup Guide From Scratch
-- https://youtu.be/FGVY7gbaoQI (https://github.com/Sin-cy/dotfiles/blob/main/nvim/.config/nvim/lua/sethy/core/keymaps.lua)

vim.g.mapleader = " "

local opts = { noremap = true, silent = true }
local keymap = vim.keymap

-- Helper function to merge defaults with per-mapping options
local function map(mode, lhs, rhs, extra_opts)
  local options = vim.tbl_extend("force", opts, extra_opts or {})
  keymap.set(mode, lhs, rhs, options)
end

map("i", "jk", "<ESC>", { desc = "Exit i mode with jk" })
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
keymap.set("n", "??", "ZZ", { noremap = true, silent = true, desc = "Save file" })

-- Navigate between tree explorer and editor
keymap.set("n", "<C-Left>", "<cmd>NvimTreeFocus<CR>", { desc = "Focus Explorer" })
keymap.set("n", "<C-Right>", "<cmd>wincmd p<CR>", { desc = "Focus Back to Buffer" })
--
-- Copy filepath to the clipboard
keymap.set("n", "<leader>fp", function()
  local filePath = vim.fn.expand("%:~") -- Gets the file path relative to the home directory
  vim.fn.setreg("+", filePath) -- Copy the file path to the clipboard register
  print("File path copied to clipboard: " .. filePath) -- Optional: print message to confirm
end, { desc = "Copy file path to clipboard" })

-- Toggle LSP diagnostics visibility
local isLspDiagnosticsVisible = true
vim.keymap.set("n", "<leader>lx", function()
  isLspDiagnosticsVisible = not isLspDiagnosticsVisible
  vim.diagnostic.config({
    virtual_text = isLspDiagnosticsVisible,
    underline = isLspDiagnosticsVisible,
  })
end, { desc = "Toggle LSP diagnostics" })

-- New Terminal
map("n", "<leader>t", function()
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

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

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

keymap.set("n", "gd", function()
  require("telescope.builtin").lsp_definitions()
end, { noremap = true, silent = true, desc = "Go to definition (LSP)" })

keymap.set("n", "<leader>u", function()
  require("telescope.builtin").lsp_references()
end, { noremap = true, silent = true, desc = "Find all references (LSP)" })

keymap.set(
  "v",
  "<S-C-Down>",
  ":m '>+1<CR>gv=gv",
  { noremap = true, silent = true, desc = "moves lines down in visual selection" }
)
keymap.set(
  "v",
  "<S-C-Up>",
  ":m '<-2<CR>gv=gv",
  { noremap = true, silent = true, desc = "moves lines up in visual selection" }
)

keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, centre" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, centre" })

-- The mapping changes their behavior so that after jumping:
-- zzz centers the cursor line in the window (like zz).
-- v reopens any folds at the cursor position (like zv).
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Paste in Visual Mode Without Overwriting Clipboard
keymap.set("x", "<leader>p", [["_dP]])

-- Paste in Visual Mode Without Overwriting Clipboard (Alternative)
keymap.set("v", "p", '"_dp', opts)

-- Delete Without Affecting Clipboard
keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Prevents deleted characters from copying to clipboard.
keymap.set("n", "x", '"_x', opts)

-- Executes shell command from in here making file executable
keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

-- Join lines
keymap.set("n", "J", "mzJ`z")

-- Git log
keymap.set("n", "<leader>gl", "<cmd>Flogsplit<CR>", { desc = "Git log" })

-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Exit Insert Mode with Ctrl+C
keymap.set("i", "<C-c>", "<Esc>")
--
-- Replace the word cursor is on globally
keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)

keymap.set("n", "vw", "viw", { noremap = true })

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
