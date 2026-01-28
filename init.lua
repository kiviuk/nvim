-- Add this to the absolute top of the file
if vim.loader then
  vim.loader.enable()
end

-- Disable python provider
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.g.python3_host_prog = '/opt/homebrew/bin/python3'

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("h.lazy")
require("h.core")
