return {
  "echasnovski/mini.ai",
  version = false, -- Recommended to use latest development version
  config = function()
    require("mini.ai").setup({})
  end,
}

-- Text Object	What it does
-- iq	Inside any configured quote
-- ib	Inside parentheses
-- if	Inside function call
-- ia	Inside argument

-- # Command	Action
-- diq	Delete inside any configured quote
-- daq	Delete around any configured quote
-- ciq	Change inside any configured quote
-- caq	Change around any configured quote
-- viq	Select inside any configured quote
-- vaq	Select around any configured quote
--
-- Any operator (d, c, y, v, etc.) can be used with iq or aq to operate on the inside or around the custom text object.
--
-- How It Works

-- iq stands for "inner quote" (inside the quotes, not including the quotes themselves).

-- aq stands for "around quote" (includes the quotes themselves).

-- You can use any operator before iq or aq to perform actions like delete, change, yank, or select
