return {
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"echasnovski/mini.basics",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("mini.basics").setup()
		end,
	},
	{
		"echasnovski/mini.bracketed",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("mini.bracketed").setup()
		end,
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("mini.comment").setup()
		end,
	},
	{
		"echasnovski/mini.move",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("mini.move").setup()
		end,
	},
	{
		"echasnovski/mini.operators",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("mini.operators").setup()
		end,
	},
	{
		"echasnovski/mini.splitjoin",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("mini.splitjoin").setup()
		end,
	},
	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("mini.pairs").setup({
				modes = { insert = true, command = true, terminal = false },
				-- skip autopair when next character is one of these
				skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
				-- skip autopair when the cursor is inside these treesitter nodes
				skip_ts = { "string" },
				-- skip autopair when next character is closing pair
				-- and there are more closing pairs than opening pairs
				skip_unbalanced = true,
				-- better deal with markdown code blocks
				markdown = true,
			})
		end,
	},
}
