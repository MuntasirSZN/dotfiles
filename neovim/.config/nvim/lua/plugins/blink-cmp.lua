local function github_pr_or_issue_configure_score_offset(items)
	-- Bonus to make sure items sorted as below:
	local keys = {
		-- place `kind_name` here
		{ "OPENIssue", "REOPENEDIssue" },
		{ "OPENPR" },
		{ "COMPLETEDIssue" },
		{ "DRAFTPR" },
		{ "MERGEDPR" },
		{ "CLOSEDPR", "NOT_PLANNEDIssue" },
	}
	local bonus = 999999
	local bonus_score = {}
	for i = 1, #keys do
		for _, key in ipairs(keys[i]) do
			bonus_score[key] = bonus * (#keys - i)
		end
	end
	for i = 1, #items do
		local bonus_key = items[i].kind_name
		if bonus_score[bonus_key] then
			items[i].score_offset = bonus_score[bonus_key]
		end
		-- sort by number when having the same bonus score
		local number = items[i].label:match("#(%d+)")
		if number then
			if items[i].score_offset == nil then
				items[i].score_offset = 0
			end
			items[i].score_offset = items[i].score_offset + tonumber(number)
		end
	end
end

return {
	{
		"xzbdmw/colorful-menu.nvim",
		event = "BufEnter",
		config = function()
			require("colorful-menu").setup({})
		end,
	},
	{
		"saghen/blink.cmp",
		lazy = false,
		event = "InsertEnter",
		version = "*",
		dependencies = {
			-- Snippets
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
			-- Completion sources
			"mikavilpas/blink-ripgrep.nvim",
			"moyiz/blink-emoji.nvim",
			"MahanRahmati/blink-nerdfont.nvim",
			"fang2hou/blink-copilot",
			{
				"Kaiser-Yang/blink-cmp-dictionary",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
			{
				"Kaiser-Yang/blink-cmp-git",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
			-- Compatibility Layer
			{
				"saghen/blink.compat",
				---@module 'blink.compat'
				---@type blink.compat.Config
				opts = {
					impersonate_nvim_cmp = true,
				},
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
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
				compat = { "crates" },
				default = function()
					local sources = {
						"lsp",
						"path",
						"snippets",
						"buffer",
						"lazydev",
						"dadbod",
						"ripgrep",
						"copilot",
						"crates",
						"dictionary",
						"git",
					}
					local filetype = vim.bo.filetype
					local emoji_filetypes = {
						"markdown",
						"norg",
						"rmd",
						"org",
						"mdx",
					}

					if vim.tbl_contains(emoji_filetypes, filetype) then
						table.insert(sources, "emoji")
						table.insert(sources, "nerdfont")
					end
					return sources
				end,
				providers = {
					nerdfont = {
						module = "blink-nerdfont",
						name = "Nerd Fonts",
						score_offset = 15, -- Tune by preference
						opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
						transform_items = function(_, items)
							local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
							local kind_idx = #CompletionItemKind + 1
							CompletionItemKind[kind_idx] = "NerdFont"
							for _, item in ipairs(items) do
								item.kind = kind_idx
							end
							return items
						end,
					},
					lsp = {
						override = {
							get_trigger_characters = function(self)
								local trigger_characters = self:get_trigger_characters()
								vim.list_extend(trigger_characters, { "\n", "\t", " " })
								return trigger_characters
							end,
						},
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
						async = true,
					},
					ripgrep = {
						module = "blink-ripgrep",
						name = "Ripgrep",
						async = true,
						transform_items = function(_, items)
							local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
							local kind_idx = #CompletionItemKind + 1
							CompletionItemKind[kind_idx] = "Ripgrep"
							for _, item in ipairs(items) do
								item.kind = kind_idx
							end
							return items
						end,
						---@module "blink-ripgrep"
						---@type blink-ripgrep.Options
						opts = {},
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						async = true,
						opts = { insert = true }, -- Insert emoji (default) or complete its name
						transform_items = function(_, items)
							local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
							local kind_idx = #CompletionItemKind + 1
							CompletionItemKind[kind_idx] = "Emoji"
							for _, item in ipairs(items) do
								item.kind = kind_idx
							end
							return items
						end,
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
					dictionary = {
						module = "blink-cmp-dictionary",
						name = "Dict",
						-- Make sure this is at least 2.
						-- 3 is recommended
						async = true,
						min_keyword_length = 3,
						opts = {
							dictionary_files = {
								vim.fn.expand("~/.config/nvim/words/words.txt"),
							},
							separate_output = function(output)
								local items = {}
								for line in output:gmatch("[^\r\n]+") do
									table.insert(items, {
										label = line,
										insert_text = line,
										-- If you want to disable the documentation feature, just set it to nil
										documentation = {
											get_command = "dict",
											get_command_args = {
												line,
											},
											---@diagnostic disable-next-line: redefined-local
											resolve_documentation = function(output)
												return output
											end,
										},
									})
								end
								return items
							end,
						},
					},
					git = {
						module = "blink-cmp-git",
						name = "Git",
						enabled = true,
						async = true,
						should_show_items = function()
							return vim.o.filetype == "gitcommit" or vim.o.filetype == "markdown"
						end,
						---@module "blink-cmp-git"
						---@type blink-cmp-git.Options
						opts = {
							kind_icons = {
								OPENPR = "",
								CLOSEDPR = "",
								MERGEDPR = "",
								DRAFTPR = "",
								OPENIssue = "",
								REOPENEDIssue = "",
								COMPLETEDIssue = "",
								NOT_PLANNEDIssue = "",
								Mention = "",
							},
							git_centers = {
								github = {
									issue = {
										get_kind_name = function(item)
											-- OPENIssue, REOPENIssue, CONFIRMEDIssue, NOT_PLANEDIssue
											return (item.stateReason or item.state) .. "Issue"
										end,
										configure_score_offset = github_pr_or_issue_configure_score_offset,
									},
									pull_request = {
										get_kind_name = function(item)
											-- OPENPR, CLOSEDPR, MERGEDPR, DRAFTPR
											return item.isDraft and "DRAFTPR" or item.state .. "PR"
										end,
										configure_score_offset = github_pr_or_issue_configure_score_offset,
									},
								},
							},
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
				nerd_font_variant = "normal",
				kind_icons = {
					Emoji = "󰞅",
					Ripgrep = "󱎸",
					NerdFont = "",
					Array = "",
					Boolean = "󰨙",
					Class = "",
					Codeium = "󰘦",
					Color = "",
					Control = "",
					Collapsed = "",
					Constant = "",
					Constructor = "",
					Copilot = "",
					Enum = "",
					EnumMember = "",
					Event = "",
					Field = "",
					File = "",
					Folder = "",
					Function = "󰊕",
					Interface = "",
					Key = "",
					Keyword = "",
					Method = "",
					Namespace = "󰦮",
					Null = "",
					Number = "󰎠",
					Object = "",
					Operator = "",
					Property = "",
					Reference = "",
					Snippet = "",
					String = "",
					Struct = " ",
					TabNine = "󰏚",
					Text = "",
					TypeParameter = "",
					Unit = "",
					Value = "",
					Variable = "",
					Module = "󰏗",
					Package = "󰆦",
				},
			},
		},
		---@param opts blink.cmp.Config | { sources: { compat: string[] } }
		config = function(_, opts)
			local blink_cmp_kind_name_highlight = {
				Commit = { default = false, fg = "#a6e3a1" },
				Mention = { default = false, fg = "#a6e3a1" },
				OPENPR = { default = false, fg = "#a6e3a1" },
				OPENIssue = { default = false, fg = "#a6e3a1" },
				REOPENEDIssue = { default = false, fg = "#a6e3a1" },
				CLOSEDPR = { default = false, fg = "#f38ba8" },
				MERGEDPR = { default = false, fg = "#cba6f7" },
				COMPLETEDIssue = { default = false, fg = "#cba6f7" },
				DRAFTPR = { default = false, fg = "#9399b2" },
				NOT_PLANNEDIssue = { default = false, fg = "#626972" },
			}
			for kind_name, hl in pairs(blink_cmp_kind_name_highlight) do
				vim.api.nvim_set_hl(0, "BlinkCmpKind" .. kind_name, hl)
			end
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
