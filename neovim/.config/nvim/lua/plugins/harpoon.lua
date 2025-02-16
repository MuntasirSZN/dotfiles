return {
	"ThePrimeagen/harpoon",
	event = "VeryLazy",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = function()
		local harpoon = lazy_require("harpoon")
		local keys = {
			{
				"<leader>h",
				function() end,
				desc = "+harpoon",
			},
			{
				"<leader>ha",
				function()
					harpoon:list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"<leader>hq",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon Quick Menu",
			},
			{
				"<leader>hp",
				function()
					harpoon:list():prev()
				end,
				desc = "Harpoon Go To Previous Buffer",
			},
			{
				"<leader>hn",
				function()
					harpoon:list():next()
				end,
				desc = "Harpoon Go To Next Buffer",
			},
		}

		for i = 1, 5 do
			table.insert(keys, {
				"<leader>h" .. i,
				function()
					require("harpoon"):list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end

		return keys
	end,
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup({})
	end,
}
