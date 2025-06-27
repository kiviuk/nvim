return {
  "thePrimeagen/harpoon",
  event = "VeryLazy",
  enabled = true,
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    local conf = require("telescope.config").values

    harpoon:setup({
      global_settings = {
        save_on_toggle = true,
        save_on_change = true,
      },
    })

    -- NOTE: Experimenting
    -- Telescope into Harpoon function
    -- comment this function if you don't like it
    -- local function toggle_telescope(harpoon_files)
    -- 	local file_paths = {}
    -- 	for _, item in ipairs(harpoon_files.items) do
    -- 		table.insert(file_paths, item.value)
    -- 	end
    -- 	require("telescope.pickers")
    -- 		.new({}, {
    -- 			prompt_title = "Harpoon",
    -- 			finder = require("telescope.finders").new_table({
    -- 				results = file_paths,
    -- 			}),
    -- 			previewer = conf.file_previewer({}),
    -- 			sorter = conf.generic_sorter({}),
    -- 		})
    -- 		:find()
    -- end

    --Harpoon Nav Interface
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon add file" })
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    -- -- Mark current file
    -- keymap.set("n", "<leader>ha", function()
    --   require("harpoon.mark").add_file()
    -- end, { desc = "Harpoon current file" })
    -- -- Toggle Harpoon menu
    -- keymap.set("n", "<leader>hm", function()
    --   require("harpoon.ui").toggle_quick_menu()
    -- end, { desc = "Toggle Harpoon menu" })
    -- -- Navigate to marked files
    -- keymap.set("n", "<leader>hn", function()
    --   require("harpoon.ui").nav_next()
    -- end, { desc = "Harpoon to next file" })
    -- keymap.set("n", "<leader>hy", function()
    --   require("harpoon.ui").nav_prev()
    -- end, { desc = "Harpoon to previous file" })
    --
    -- --Harpoon marked files
    -- vim.keymap.set("n", "<C-y>", function()
    --   harpoon:list():select(1)
    -- end)
    -- vim.keymap.set("n", "<C-i>", function()
    --   harpoon:list():select(2)
    -- end)
    -- vim.keymap.set("n", "<C-n>", function()
    --   harpoon:list():select(3)
    -- end)
    -- vim.keymap.set("n", "<C-s>", function()
    --   harpoon:list():select(4)
    -- end)
    --
    -- -- Toggle previous & next buffers stored within Harpoon list
    -- vim.keymap.set("n", "<C-S-P>", function()
    --   harpoon:list():prev()
    -- end)
    -- vim.keymap.set("n", "<C-S-N>", function()
    --   harpoon:list():next()
    -- end)
    --
    -- Telescope inside Harpoon Window
    -- vim.keymap.set("n", "<C-f>", function()
    -- 	toggle_telescope(harpoon:list())
    -- end)
  end,
}
