return {
	{
		"saghen/blink.cmp",
		lazy = false,
		version = "*",
		dependencies = {
			{ "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			{ "saghen/blink.compat", version = "*", opts = { impersonate_nvim_cmp = true } },
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			accept = {
				expand_snippet = function(snippet)
					require("luasnip").lsp_expand(snippet)
				end,
			},
			sources = {
				completion = {
					enabled_providers = { "luasnip", "lsp", "path", "snippets", "buffer" },
				},
				providers = {
					luasnip = {
						name = "luasnip",
						module = "blink.compat.source",

						score_offset = -3,

						opts = {
							use_show_condition = false,
							show_autosnippets = true,
						},
					},
				},
			},
			keymap = { preset = "enter" },
			vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#212136", fg = "#cdd6f4" }),
			vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "#1e1e2e", fg = "#585b70" }),
			vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#212136", fg = "#cdd6f4" }),
			vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "#1e1e2e", fg = "#585b70" }),
			highlight = {
				use_nvim_cmp_as_default = true,
			},
			nerd_font_variant = "normal",
			windows = {
				autocomplete = {
					draw = {
						columns = { {"kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
					},
				},
			},
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
				Variable = "  ",
			},
		},
	},
}
