return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
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
      "go",
    }
    
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })
    
    require("nvim-treesitter").install(parsers)
    
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "json", "yaml", "toml", "python", "clojure", "requirements", "markdown", "bash", "lua", "vim", "gitignore", "java", "scala", "rust", "go" },
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
