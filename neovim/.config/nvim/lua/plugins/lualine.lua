return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"AndreM222/copilot-lualine",
	},
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			-- set an empty statusline till lualine loads
			vim.o.statusline = " "
		else
			-- hide the statusline on the starter page
			vim.o.laststatus = 0
		end
	end,
	config = function()
		local lazyvim_lualine = require("custom.lazyvim-lualine")
		local icons = require("custom.icons")

		local opts = {
			options = {
				icons_enabled = true,
				theme = "catppuccin",
				globalstatus = vim.o.laststatus == 3,
				component_separators = { left = " ", right = " " },
				disabled_filetypes = {
					statusline = {
						"starter",
						"dashboard",
						"alpha",
						"ministarter",
						"snacks_terminal",
					},
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
				},
				lualine_c = {
					lazyvim_lualine.root_dir(),
					{
						"filetype",
						icon_only = true,
						separator = "",
						padding = { left = 1, right = 0 },
					},
					{ lazyvim_lualine.pretty_path() },
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
						sources = { "nvim_diagnostic" },
					},
				},
				lualine_x = {
					{ "require'wttr'.text" },
					{ require("mcphub.extensions.lualine") },
					Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },
					require("ecolog").get_lualine(),
					{
						function()
							return require("lazydo").get_lualine_stats() -- status
						end,
						cond = function()
							return lazy_require("lazydo")._initialized -- condition for lualine
						end,
					},
					{
						"copilot",
						show_colors = true,
					},
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
					"fileformat",
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
					{
						function()
							return require("vectorcode.integrations").lualine()[1]()
						end,
						cond = function()
							if package.loaded["vectorcode"] == nil then
								return false
							else
								return require("vectorcode.integrations").lualine().cond()
							end
						end,
					},
				},
				lualine_z = {
					function()
						return " " .. os.date("%I:%M %p")
					end,
				},
			},
			extensions = {
				"lazy",
				"man",
				"mason",
				"quickfix",
				"neo-tree",
				"nvim-dap-ui",
				"trouble",
			},
		}

		require("lualine").setup(opts)

		vim.g.trouble_lualine = true

		-- do not add trouble symbols if aerial is enabled
		-- And allow it to be overridden for some buffer types (see autocmds)
		if vim.g.trouble_lualine and require("lazy.core.config").spec.plugins["trouble.nvim"] then
			local trouble = require("trouble")
			local symbols = trouble.statusline({
				mode = "symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
				hl_group = "lualine_c_normal",
			})
			table.insert(opts.sections.lualine_c, {
				symbols and symbols.get,
				cond = function()
					return vim.b.trouble_lualine ~= false and symbols.has()
				end,
			})
		end
	end,
}
