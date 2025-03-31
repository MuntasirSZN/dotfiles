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
		local catppuccin_flavours = {
			["catppuccin-mocha"] = "mocha",
			["catppuccin-macchiato"] = "macchiato",
			["catppuccin-frappe"] = "frappe",
			["catppuccin-latte"] = "latte",
		}

		local catppuccin_flavor_set = {
			mocha = true,
			macchiato = true,
			frappe = true,
			latte = true,
		}

		local function get_flavor()
			local theme = require("themery").getCurrentTheme()
			if not theme then
				return
			end
			return catppuccin_flavours[theme.name] or theme.name
		end

		local function get_flavoured_theme()
			local theme_name = get_flavor()
			if not theme_name then
				return
			end

			if catppuccin_flavor_set[theme_name] then
				local lualine_theme = require("catppuccin.utils.lualine")(theme_name)

				-- Clear background for specific sections
				local clear_bg_sections = {
					normal = { c = true },
					inactive = { a = true, b = true, c = true },
				}

				for section, parts in pairs(clear_bg_sections) do
					for part in pairs(parts) do
						lualine_theme[section][part].bg = "NONE"
					end
				end

				return lualine_theme
			end

			return theme_name
		end
		local lazyvim_lualine = require("custom.lazyvim_lualine")
		local opts = {
			options = {
				icons_enabled = true,
				theme = get_flavoured_theme(),
				globalstatus = vim.o.laststatus == 3,
				disabled_filetypes = {
					winbar = {
						"aerial",
						"NvimTree",
						"neo-tree",
						"starter",
						"Trouble",
						"qf",
						"NeogitStatus",
						"NeogitCommitMessage",
						"NeogitPopup",
					},
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
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
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
