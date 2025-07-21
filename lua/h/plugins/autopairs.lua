return {
  "windwp/nvim-autopairs",
  config = function()
    -- import nvim-autopairs
    local autopairs = require("nvim-autopairs")

    -- Before        Input                    After         Note
    -- -----------------------------------------------------------------
    -- (|foobar      <M-e> then press $       (|foobar)
    -- (|)(foobar)   <M-e> then press q       (|(foobar))
    -- (|foo bar     <M-e> then press qh      (|foo) bar
    -- (|foo bar     <M-e> then press qH      (foo|) bar
    -- (|foo bar     <M-e> then press qH      (foo)| bar    if cursor_pos_before = false

    -- configure autopairs
    autopairs.setup({
      check_ts = true,
      fast_wrap = {
        map = '<M-g>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey = 'Comment',
      },
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    })
    -- autopairs.setup({
    --   check_ts = true, -- enable treesitter
    --   ts_config = {
    --     lua = { "string" }, -- don't add pairs in lua string treesitter nodes
    --     javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
    --     java = false, -- don't check treesitter on java
    --   },
    --   fast_wrap = {},
    -- })

    require("nvim-autopairs.ts-conds")
  end,
}
