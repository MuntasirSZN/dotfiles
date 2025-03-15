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
				-- In which modes mappings from this `config` should be created
				modes = { insert = true, command = true, terminal = false },
				-- Global mappings. Each right hand side should be a pair information, a
				-- table with at least these fields (see more in |MiniPairs.map|):
				-- - <action> - one of 'open', 'close', 'closeopen'.
				-- - <pair> - two character string for pair to be used.
				-- By default pair is not inserted after `\`, quotes are not recognized by
				-- `<CR>`, `'` does not insert pair after a letter.
				-- Only parts of tables can be tweaked (others will use these defaults).
				mappings = {
					[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
					["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
					["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
					["["] = {
						action = "open",
						pair = "[]",
						neigh_pattern = ".[%s%z%)}%]]",
						register = { cr = false },
						-- foo|bar -> press "[" -> foo[bar
						-- foobar| -> press "[" -> foobar[]
						-- |foobar -> press "[" -> [foobar
						-- | foobar -> press "[" -> [] foobar
						-- foobar | -> press "[" -> foobar []
						-- {|} -> press "[" -> {[]}
						-- (|) -> press "[" -> ([])
						-- [|] -> press "[" -> [[]]
					},
					["{"] = {
						action = "open",
						pair = "{}",
						-- neigh_pattern = ".[%s%z%)}]",
						neigh_pattern = ".[%s%z%)}%]]",
						register = { cr = false },
						-- foo|bar -> press "{" -> foo{bar
						-- foobar| -> press "{" -> foobar{}
						-- |foobar -> press "{" -> {foobar
						-- | foobar -> press "{" -> {} foobar
						-- foobar | -> press "{" -> foobar {}
						-- (|) -> press "{" -> ({})
						-- {|} -> press "{" -> {{}}
					},
					["("] = {
						action = "open",
						pair = "()",
						-- neigh_pattern = ".[%s%z]",
						neigh_pattern = ".[%s%z%)]",
						register = { cr = false },
						-- foo|bar -> press "(" -> foo(bar
						-- foobar| -> press "(" -> foobar()
						-- |foobar -> press "(" -> (foobar
						-- | foobar -> press "(" -> () foobar
						-- foobar | -> press "(" -> foobar ()
					},
					-- Single quote: Prevent pairing if either side is a letter
					['"'] = {
						action = "closeopen",
						pair = '""',
						neigh_pattern = "[^%w\\][^%w]",
						register = { cr = false },
					},
					-- Single quote: Prevent pairing if either side is a letter
					["'"] = {
						action = "closeopen",
						pair = "''",
						neigh_pattern = "[^%w\\][^%w]",
						register = { cr = false },
					},
					-- Backtick: Prevent pairing if either side is a letter
					["`"] = {
						action = "closeopen",
						pair = "``",
						neigh_pattern = "[^%w\\][^%w]",
						register = { cr = false },
					},
				},
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
