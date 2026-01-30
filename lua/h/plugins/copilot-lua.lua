return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true, -- Start suggesting as soon as you stop typing
        debounce = 75,       -- Fast response time (default is 75ms)
        keymap = {
          accept = "<C-J>",  -- Control+J to accept
          next = "<M-]>",    -- Alt+] for next suggestion
          prev = "<M-[>",    -- Alt+[ for prev suggestion
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false }, -- Disable the panel if you don't use it
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
    })
  end,
}