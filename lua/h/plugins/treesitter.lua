return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local parsers = {
      "json",
      "yaml",
      "toml",
      "python",
      "clojure",
      "requirements",
      "markdown",
      "bash",
      "lua",
      "vim",
      "gitignore",
      "java",
      "scala",
      "rust",
    }

    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "json",
        "yaml",
        "toml",
        "python",
        "clojure",
        "requirements",
        "markdown",
        "bash",
        "lua",
        "vim",
        "gitignore",
        "java",
        "scala",
        "rust",
      },
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local max_filesize = 1024 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return
        end
        vim.treesitter.start(buf)
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "json",
        "yaml",
        "toml",
        "python",
        "clojure",
        "bash",
        "lua",
        "vim",
        "java",
        "scala",
        "rust",
      },
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
