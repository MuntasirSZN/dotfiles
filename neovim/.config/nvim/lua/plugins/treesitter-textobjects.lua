return -- nvim-treesitter-textobjects configuration
{
	"nvim-treesitter/nvim-treesitter-textobjects",
	event = "VeryLazy",
	enabled = true,
	config = function()
		-- If treesitter is already loaded, we need to run config again for textobjects
		if pcall(require, "nvim-treesitter") then
			local opts = {
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			}
			require("nvim-treesitter.configs").setup({ textobjects = opts.textobjects })
		end

		-- When in diff mode, we want to use the default
		-- vim text objects c & C instead of the treesitter ones.
		local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
		local configs = require("nvim-treesitter.configs")
		for name, fn in pairs(move) do
			if name:find("goto") == 1 then
				move[name] = function(q, ...)
					if vim.wo.diff then
						local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
						for key, query in pairs(config or {}) do
							if q == query and key:find("[%]%[][cC]") then
								vim.cmd("normal! " .. key)
								return
							end
						end
					end
					return fn(q, ...)
				end
			end
		end
	end,
}
