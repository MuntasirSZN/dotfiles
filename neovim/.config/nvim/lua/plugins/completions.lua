return {
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			require("colorful-menu").setup({})
		end,
	},
	{
		"saghen/blink.cmp",
		lazy = false,
		version = "*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
			"mikavilpas/blink-ripgrep.nvim",
			"moyiz/blink-emoji.nvim",
			"fang2hou/blink-copilot",
			{
				"saghen/blink.compat",
				optional = true, -- make optional so it's only enabled if any plugins need it
				opts = {},
				version = "*",
			},
		},
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			snippets = {
				preset = "luasnip",
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
				compat = {},
				default = function()
					local sources = {
						"lsp",
						"path",
						"snippets",
						"buffer",
						"codecompanion",
						"lazydev",
						"dadbod",
						"ripgrep",
						"copilot",
					}
					local filetype = vim.bo.filetype
					local emoji_filetypes = {
						"markdown",
						"norg",
						"rmd",
						"org",
						"mdx",
						"codecompanion",
					}

					if vim.tbl_contains(emoji_filetypes, filetype) then
						table.insert(sources, "emoji")
					end
					return sources
				end,
				providers = {
					lsp = {
						override = {
							get_trigger_characters = function(self)
								local trigger_characters = self:get_trigger_characters()
								vim.list_extend(trigger_characters, { "\n", "\t", " " })
								return trigger_characters
							end,
						},
					},
					codecompanion = {
						name = "CodeCompanion",
						module = "codecompanion.providers.completion.blink",
						enabled = true,
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100, -- show at a higher priority than lsp
					},
					dadbod = {
						name = "Dadbod",
						module = "vim_dadbod_completion.blink",
						score_offset = 85, -- the higher the number, the higher the priority
					},
					ripgrep = {
						module = "blink-ripgrep",
						name = "Ripgrep",
						---@module "blink-ripgrep"
						---@type blink-ripgrep.Options
						opts = {},
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						opts = { insert = true }, -- Insert emoji (default) or complete its name
					},
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
						opts = {
							max_completions = 3,
							max_attempts = 4,
						},
					},
				},
			},
			keymap = {
				preset = "super-tab",
			},
			signature = { enabled = true },
			completion = {
				trigger = {
					show_on_blocked_trigger_characters = {},
				},
				list = {
					selection = {
						auto_insert = false,
					},
				},
				accept = {
					-- experimental auto-brackets support
					auto_brackets = {
						enabled = true,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				menu = {
					auto_show = true,
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
							kind_icon = {
								text = function(ctx)
									if
										require("blink.cmp.completion.windows.render.tailwind").get_hex_color(ctx.item)
									then
										return "󱓻"
									end
									return ctx.kind_icon .. ctx.icon_gap
								end,
							},
						},
					},
				},
			},
			appearance = {
				nerd_font_variant = "mono",
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
		---@param opts blink.cmp.Config | { sources: { compat: string[] } }
		config = function(_, opts)
			-- setup compat sources
			local enabled = opts.sources.default
			for _, source in ipairs(opts.sources.compat or {}) do
				opts.sources.providers[source] = vim.tbl_deep_extend(
					"force",
					{ name = source, module = "blink.compat.source" },
					opts.sources.providers[source] or {}
				)
				if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
					table.insert(enabled, source)
				end
			end
			opts.sources.compat = nil
			-- check if we need to override symbol kinds
			for _, provider in pairs(opts.sources.providers or {}) do
				---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
				if provider.kind then
					local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
					local kind_idx = #CompletionItemKind + 1

					CompletionItemKind[kind_idx] = provider.kind
					---@diagnostic disable-next-line: no-unknown
					CompletionItemKind[provider.kind] = kind_idx

					---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
					local transform_items = provider.transform_items
					---@param ctx blink.cmp.Context
					---@param items blink.cmp.CompletionItem[]
					provider.transform_items = function(ctx, items)
						items = transform_items and transform_items(ctx, items) or items
						for _, item in ipairs(items) do
							item.kind = kind_idx or item.kind
						end
						return items
					end

					-- Unset custom prop to pass blink.cmp validation
					provider.kind = nil
				end
			end

			require("blink.cmp").setup(opts)
		end,
	},
}
