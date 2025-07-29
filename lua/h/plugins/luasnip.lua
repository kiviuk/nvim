return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  -- follow latest release.
  version = "v2.*",
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    -- Load snippets from friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
