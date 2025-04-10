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
		local function get_flavoured_theme()
			local lualine_theme = require("catppuccin.utils.lualine")(require("catppuccin").options.flavour)

			-- Clear background for specific sections
			local clear_bg_sections = {
				inactive = { a = "NONE", b = "NONE", c = "NONE" },
			}
			lualine_theme = vim.tbl_extend("force", lualine_theme, clear_bg_sections)

			return lualine_theme
		end
		local lazyvim_lualine = require("custom.lazyvim_lualine")
		local opts = {
			options = {
				icons_enabled = true,
				theme = get_flavoured_theme(),
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
							error = require("custom.icons").diagnostics.Error,
							warn = require("custom.icons").diagnostics.Warn,
							info = require("custom.icons").diagnostics.Info,
							hint = require("custom.icons").diagnostics.Hint,
						},
						sources = { "nvim_diagnostic" },
					},
				},
				lualine_x = {
					{ require("mcphub.extensions.lualine") },
					Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
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
						cond = function()
							return not require("custom.codecompanion_lualine").processing
						end,
					},
					{
						function()
							return require("custom.codecompanion_lualine"):update_status()
						end,
						cond = function()
							return require("custom.codecompanion_lualine").processing
						end,
					},
					{
						"diff",
						symbols = {
							added = require("custom.icons").git.added,
							modified = require("custom.icons").git.modified,
							removed = require("custom.icons").git.removed,
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

		require("custom.codecompanion_lualine"):init()

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
