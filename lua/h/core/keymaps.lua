-- https://github.com/Sin-cy/dotfiles/blob/main/nvim/.config/nvim/lua/sethy/core/keymaps.lua
-- The Ultimate Neovim Setup Guide From Scratch
-- https://youtu.be/FGVY7gbaoQI (https://github.com/Sin-cy/dotfiles/blob/main/nvim/.config/nvim/lua/sethy/core/keymaps.lua)

-- Open new line below or above
-- while in insert mode type ctrl + o then o
-- while in insert mode type ctrl + o then O

vim.g.mapleader = " "

local opts = { noremap = true, silent = true }
local keymap = vim.keymap

-- Helper function to merge defaults with per-mapping options
local function map(mode, lhs, rhs, extra_opts)
  local options = vim.tbl_extend("force", opts, extra_opts or {})
  keymap.set(mode, lhs, rhs, options)
end

-- Exit insert mode
map("i", "jk", "<ESC>", { desc = "Exit i mode with jk" })

-- Clear search highlights
keymap.set("n", "<leader>.", ":nohl<CR>", { desc = "Clear search highlights" })

-- Set 0 to the first non-whitespace character in line
vim.keymap.set("n", "0", "^", { noremap = true })
vim.keymap.set("n", "^", "0", { noremap = true })

-- Visual mode
-- Set 0 to the first non-whitespace character in line
vim.keymap.set("v", "0", "^", { noremap = true })
vim.keymap.set("v", "^", "0", { noremap = true })

-- inc/dec numbers
keymap.set("n", "<leader>=", "<C-a>", { desc = "Inc numb" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Dec numb" })

-- window management
keymap.set("n", "<leader>sh", "<C-w>v", { desc = "Split window vert" })
keymap.set("n", "<leader>sv", "<C-w>s", { desc = "Split window horiz" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Split window equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Show all keymaps
keymap.set("n", "<leader>kk", "<cmd>Telescope keymaps<CR>", { desc = "List all keymaps" })

-- Save file
keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
keymap.set("n", "??", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
keymap.set("n", "<leader><leader>s", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
keymap.set("n", "???", "ZZ", { noremap = true, silent = true, desc = "Save file" })

-- Jump to start of scala/python function
vim.keymap.set('n', 'ff', '/^\\s*def<CR>:nohlsearch<CR>zz', { noremap = true, silent = true })
vim.keymap.set('n', 'FF', '?^\\s*def<CR>:nohlsearch<CR>zz', { noremap = true, silent = true })

-- Exit insert mode and move up/down a line
vim.keymap.set('i', '<Up>', '<Esc>k', { noremap = true, silent = true })
vim.keymap.set('i', '<Down>', '<Esc>j', { noremap = true, silent = true })

-- Source
keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { noremap = true, silent = true, desc = "Source %" })

-- Copy messages to clipboard
vim.keymap.set("n", "<leader>k", function()
  vim.fn.setreg("*", vim.fn.trim(vim.fn.execute("1messages")))
  vim.notify("copied", vim.log.levels.INFO)
end, { desc = "Copy :messages to clipboard" })

-- Navigate between tree explorer and editor
-- keymap.set("n", "<C-Left>", "<cmd>NvimTreeFocus<CR>", { desc = "Focus Explorer" })
-- keymap.set("n", "<C-Right>", "<cmd>wincmd p<CR>", { desc = "Focus Back to Buffer" })
--
-- Copy filepath to the clipboard
keymap.set("n", "<leader>fp", function()
  local filePath = vim.fn.expand("%:~")                -- Gets the file path relative to the home directory
  vim.fn.setreg("+", filePath)                         -- Copy the file path to the clipboard register
  print("File path copied to clipboard: " .. filePath) -- Optional: print message to confirm
end, { desc = "Copy file path to clipboard" })

-- Toggle LSP diagnostics visibility
local isLspDiagnosticsVisible = false
vim.keymap.set("n", "<leader>lx", function()
  isLspDiagnosticsVisible = not isLspDiagnosticsVisible
  vim.diagnostic.config({
    virtual_text = isLspDiagnosticsVisible,
    underline = isLspDiagnosticsVisible,
  })
end, { desc = "Toggle LSP diagnostics" })

-- Toggle LSP Symbols
vim.keymap.set('n', '<leader>ll', '<cmd>Telescope lsp_document_symbols<cr>', { desc = 'LSP Symbols (outline)' })
vim.keymap.set('n', '<leader>lt', '<cmd>Telescope treesitter<cr>', { desc = 'Treesitter Symbols (outline)' })

-- Only methods
vim.keymap.set('n', '<leader>lm',
  function() require('telescope.builtin').lsp_document_symbols({ symbols = { 'method' } }) end,
  { desc = 'LSP Symbols: methods only' })

-- Methods AND functions
vim.keymap.set('n', '<leader>lf',
  function() require('telescope.builtin').lsp_document_symbols({ symbols = { 'method', 'function' } }) end,
  { desc = 'LSP Symbols: methods & functions' })

vim.keymap.set('n', '<leader>lv',
  function() require('telescope.builtin').lsp_document_symbols({ symbols = { 'variable' } }) end,
  { desc = 'LSP Symbols: variables only' })

-- Classes, interfaces, methods
vim.keymap.set('n', '<leader>lc',
  function() require('telescope.builtin').lsp_document_symbols({ symbols = { 'class', 'interface', 'method' } }) end,
  { desc = 'LSP Symbols: class/interface/method' })

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
-- vim.api.nvim_set_keymap(
--   "t",
--   "<C-h>",
--   [[<C-\><C-n><C-w>h]],
--   { noremap = true, silent = true, desc = "Switch to left window from terminal" }
-- )
-- vim.api.nvim_set_keymap(
--   "t",
--   "<C-l>",
--   [[<C-\><C-n><C-w>l]],
--   { noremap = true, silent = true, desc = "Switch to right window from terminal" }
-- )

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

-- ~~ to copy all
vim.keymap.set("n", "~~", ":%yank<CR>", { noremap = true, silent = true })

-- Map <Esc><Esc> to exit terminal mode *and* close the window
-- vim.api.nvim_set_keymap("t", "<Esc><Esc>", [[<C-\><C-n>:close<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<Esc><Esc>", [[<C-\><C-n>gt]], { noremap = true, silent = true })

-- Quickly close a terminal window if it's not the last one
-- (Note: <leader>sx already closes current split, which works for terminals too)
keymap.set("n", "<leader>tc", "<cmd>close<CR>", { desc = "Close terminal split" })


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

-- Close Neovim (force quit)
keymap.set("n", "<leader>QQ", ":qa!<CR>", { desc = "Force quit all" })

-- Save all and quit
keymap.set("n", "<leader>QS", function()
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

-- Activate Zen Mode
vim.keymap.set("n", "<leader>z", function()
  require("zen-mode").toggle()
end, { desc = "Toggle Zen Mode" })

-- Move lines
keymap.set(
  "v",
  "<S-A-Down>",
  ":m '>+1<CR>gv=gv",
  { noremap = true, silent = true, desc = "Move lines down in visual selection" }
)
keymap.set(
  "v",
  "<S-A-Up>",
  ":m '<-2<CR>gv=gv",
  { noremap = true, silent = true, desc = "Move lines up in visual selection" }
)
vim.keymap.set(
  "n",
  "<S-A-Down>",
  ":m .+1<CR>==",
  { noremap = true, silent = true, desc = "Move line down in normal mode" }
)
vim.keymap.set("n", "<S-A-Up>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up in normal mode" })

-- Scroll and centre
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, centre" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, centre" })

-- The mapping changes their behavior so that after jumping:
-- zzz centers the cursor line in the window (like zz).
-- v reopens any folds at the cursor position (like zv).
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- 1. PASTE: Always paste on a new line below/above in Normal Mode
keymap.set("n", "p", ":put<CR>", { desc = "Paste on new line below" })
keymap.set("n", "P", ":put!<CR>", { desc = "Paste on new line above" })

-- 2. ADD EMPTY LINES: Without leaving Normal mode
-- Using <leader>Enter and <leader>Shift+Enter to avoid conflict with SymbolsOutline
keymap.set("n", "<leader>O", "m`O<Esc>``", { desc = "Add empty line above" })
keymap.set("n", "<leader><CR>", "o<Esc>", { desc = "Add empty line below" })

-- Paste in Visual Mode Without Overwriting Clipboard (deleted content goes /dev/null)
keymap.set("x", "<leader>p", [["_dP]], { noremap = true, silent = true, desc = "Paste without Affecting Clipboard" })

-- Paste in Visual Mode Without Overwriting Clipboard (Alternative)
keymap.set("v", "p", '"_dp', { noremap = true, silent = true, desc = "Paste without Affecting Clipboard" })

-- Delete Without Affecting Clipboard
keymap.set(
  { "n", "v" },
  "<leader>d",
  [["_d]],
  { noremap = true, silent = true, desc = "Delete without Affecting Clipboard (visual mode)" }
)

-- Prevents deleted characters from copying to clipboard.
keymap.set("n", "x", '"_x', { noremap = true, silent = true, desc = "Delete without Affecting Clipboard" })

-- Executes shell command from in here making file executable
-- keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

-- Join lines
keymap.set("n", "J", "mzJ`z")

-- Git log
keymap.set("n", "<leader>gl", "<cmd>Flogsplit<CR>", { silent = true, desc = "Git log" })

-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Duplicate current line in normal mode (Option+d)
vim.keymap.set("n", "<M-d>", ":t.<CR>", { noremap = true, silent = true })

-- Duplicate selected lines in visual mode
vim.keymap.set("v", "<C-d>", function()
  -- Copy selected lines below the selection
  vim.cmd("normal! y")
  vim.cmd("normal! `>p")
  -- Reselect the newly duplicated lines
  vim.cmd("normal! gv")
end, { noremap = true, silent = true })

-- Replace the word cursor is on globally
keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)

keymap.set("n", "vw", "viw", { noremap = true })
keymap.set("n", "vv", "viw", { desc = "Select word visually" })
keymap.set("n", "11", "ggzz", { desc = "Jump to start of file and center" })
keymap.set("n", "22", "Gzz", { desc = "Jump to end of file" })
keymap.set("n", "33", "*zz", { desc = "Search word under cursor and center" })
keymap.set("n", "vv", "viw", { desc = "Select word visually" })

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


vim.api.nvim_create_autocmd("LspAttach", {
  -- Use LspAttach autocommand to only map the following keys after the language server attaches
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "<leader>,", require("telescope.builtin").lsp_references,
      vim.tbl_extend("force", opts, { desc = "Find Usages (Telescope)" })
    )
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
      vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
    vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Document" }))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
      vim.tbl_extend("force", opts, { desc = "Code Action" }))
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition,
      vim.tbl_extend("force", opts, { desc = "Type Definition" }))

    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format { async = true }
    end, vim.tbl_extend("force", opts, { desc = "Format File" }))

    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostic List" })
    -- Open the diagnostic under the cursor in a float window
    vim.keymap.set("n", "<leader>d", function()
      vim.diagnostic.open_float {
        border = "rounded",
      }
    end, vim.tbl_extend("force", opts, { desc = "Open Diagnostic in floating window" }))
  end,
})

-- AI Chat keymaps (gp.nvim)
-- Open new chat in vertical split
vim.keymap.set("n", "<leader>ac", "<cmd>GpChatNew vsplit<CR>", { desc = "AI Chat (vsplit)" })
-- Open chat finder
vim.keymap.set("n", "<leader>af", "<cmd>GpChatFinder<CR>", { desc = "AI Chat Finder" })
-- Toggle last chat
vim.keymap.set("n", "<leader>at", "<cmd>GpChatToggle vsplit<CR>", { desc = "AI Toggle Chat" })
-- Rewrite selected code
vim.keymap.set({ "n", "v" }, "<leader>ar", "<cmd>GpRewrite<CR>", { desc = "AI Rewrite" })
-- Explain selected code - opens new chat with selection
vim.keymap.set({ "n", "v" }, "<leader>ae", ":'<,'>GpChatNew<CR>", { desc = "AI Explain" })
-- Paste selection into AI chat
vim.keymap.set("v", "<leader>ap", "<cmd>GpChatPaste<CR>", { desc = "AI Paste to chat" })
