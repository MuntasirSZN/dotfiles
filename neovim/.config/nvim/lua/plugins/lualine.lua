return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"AndreM222/copilot-lualine",
	},
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

		require("custom.lualine"):init()

		require("lualine").setup({
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
				lualine_x = {
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
							return not require("custom.lualine").processing
						end,
					},
					{
						function()
							return require("custom.lualine"):update_status()
						end,
						cond = function()
							return require("custom.lualine").processing
						end,
					},
					"encoding",
					"fileformat",
					"filetype",
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
		})
	end,
}
