return {
	{
		"saghen/blink.cmp",
		lazy = false,
		version = "*",
		dependencies = {
			{ "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
			"leiserfg/blink_luasnip",
			"rafamadriz/friendly-snippets",
			{
				"saghen/blink.compat",
				version = "*",
				opts = { impersonate_nvim_cmp = true },
			},
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			snippets = {
				expand = function(snippet)
					require("luasnip").lsp_expand(snippet)
				end,
				active = function(filter)
					if filter and filter.direction then
						return require("luasnip").jumpable(filter.direction)
					end
					return require("luasnip").in_snippet()
				end,
				jump = function(direction)
					require("luasnip").jump(direction)
				end,
			},
			sources = {
				completion = {
					enabled_providers = { "luasnip", "lsp", "path", "snippets", "buffer" },
				},
				providers = {
					luasnip = {
						name = "luasnip",
						module = "blink_luasnip",

						score_offset = -3,

						opts = {
							use_show_condition = false, -- disables filtering completion candidates
							show_autosnippets = true,
							show_ghost_text = false, -- whether to show a preview of the selected snippet (experimental)
						},
					},
				},
			},
			keymap = { preset = "enter" },
			completion = {
				menu = {
					draw = {
						columns = { { "kind_icon","label", gap = 1 }, { "kind" } },
					},
				},
			},
			vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#212136", fg = "#cdd6f4" }),
			vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "#1e1e2e", fg = "#585b70" }),
			vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#212136", fg = "#cdd6f4" }),
			vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "#1e1e2e", fg = "#585b70" }),
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "normal",
				kind_icons = {
					Array = " ",
					Boolean = "󰨙 ",
					Class = " ",
					Codeium = "󰘦 ",
					Color = " ",
					Control = " ",
					Collapsed = " ",
					Constant = "  ",
					Constructor = " ",
					Copilot = " ",
					Enum = " ",
					EnumMember = " ",
					Event = " ",
					Field = "  ",
					File = " ",
					Folder = "  ",
					Function = "󰊕 ",
					Interface = " ",
					Key = " ",
					Keyword = " ",
					Method = " ",
					Module = " ",
					Namespace = "󰦮 ",
					Null = " ",
					Number = "󰎠 ",
					Object = " ",
					Operator = " ",
					Package = " ",
					Property = " ",
					Reference = " ",
					Snippet = " ",
					String = " ",
					Struct = "  ",
					TabNine = "󰏚 ",
					Text = " ",
					TypeParameter = " ",
					Unit = " ",
					Value = " ",
					Variable = " ",
				},
			},
		},
	},
}
