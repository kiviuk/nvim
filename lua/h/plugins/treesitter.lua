-- File: lua/h/plugins/treesitter.lua (MODIFIED)
return {
  "nvim-treesitter/nvim-treesitter",
  event = "VeryLazy",
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      -- A list of parser names, or "all"
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "xml",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
        "java",
        "scala",
        "rust",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      -- === THE FIX FOR LARGE FILES IS HERE ===
      highlight = {
        enable = true,
        -- Set this to false if you want to use TSEnable highlight manually
        -- on large files.
        disable = function(lang, buf)
          local max_filesize = 1024 * 1024 -- 1 MB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,

        -- Or, if you REALLY want to parse large files, do this instead:
        -- disable = false,
        -- additional_vim_regex_highlighting = false,
      },
      -- =======================================

      indent = { enable = true },
      autotag = { enable = true },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-y>",
          node_incremental = "<C-y>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
