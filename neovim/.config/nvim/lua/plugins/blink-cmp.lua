local function pr_or_issue_configure_score_offset(items)
	-- Bonus to make sure items sorted as below:
	local keys = {
		-- place `kind_name` here
		{ "openIssue", "openedIssue", "reopenedIssue" },
		{ "openPR", "openedPR" },
		{ "lockedIssue", "lockedPR" },
		{ "completedIssue" },
		{ "draftPR" },
		{ "mergedPR" },
		{ "closedPR", "closedIssue", "not_plannedIssue", "duplicateIssue" },
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
		local number = items[i].label:match("[#!](%d+)")
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
		lazy = false,
		config = function()
			require("colorful-menu").setup({})
		end,
	},
	-- Compatibility Layer
	{
		"saghen/blink.compat",
		lazy = false,
		main = "blink-compat",
		---@module 'blink.compat'
		---@type blink.compat.Config
		opts = {},
		version = "*",
	},
	{
		"saghen/blink.cmp",
		version = "*",
		lazy = false,
		dependencies = {
			-- Snippets
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
			-- Completion sources
			"mikavilpas/blink-ripgrep.nvim",
			"moyiz/blink-emoji.nvim",
			"fang2hou/blink-copilot",
			{
				"Kaiser-Yang/blink-cmp-dictionary",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
			{
				"Kaiser-Yang/blink-cmp-git",
				dependencies = { "nvim-lua/plenary.nvim" },
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
			term = {
				enabled = true,
				sources = {
					"lsp",
					"path",
					"snippets",
					"buffer",
					"copilot",
				},
			},
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
				compat = {},
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
					"lazydev",
					"dadbod",
					"ripgrep",
					"copilot",
					"dictionary",
					"git",
					"emoji",
					"ecolog",
				},
				providers = {
					lsp = {
						opts = {
							tailwind_color_icon = require("custom.icons").misc.color_text,
						},
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 99, -- show at a higher priority than lsp
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
						should_show_items = function()
							return vim.tbl_contains(
								{ "gitcommit", "markdown", "norg", "rmd", "org", "mdx" },
								vim.o.filetype
							)
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
						transform_items = function(_, items)
							local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
							local kind_idx = #CompletionItemKind + 1
							CompletionItemKind[kind_idx] = "Copilot"
							for _, item in ipairs(items) do
								item.kind = kind_idx
							end
							return items
						end,
					},
					dictionary = {
						module = "blink-cmp-dictionary",
						name = "Dict",
						async = true,
						min_keyword_length = 3,
						opts = {
							dictionary_files = {
								vim.fn.expand("~/.config/nvim/words/words.txt"),
							},
							get_documentation = function(item)
								-- use return nil to disable the documentation
								-- return nil
								return {
									get_command = function()
										return "dict"
									end,
									get_command_args = function()
										return { item }
									end,
									resolve_documentation = function(output)
										return output
									end,
									on_error = require("blink-cmp-dictionary.default").on_error,
								}
							end,
						},
					},
					git = {
						module = "blink-cmp-git",
						name = "Git",
						async = true,
						enabled = function()
							return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
						end,
						---@module "blink-cmp-git"
						---@type blink-cmp-git.Options
						opts = {
							kind_icons = require("custom.icons").blink_cmp_git,
							commit = {
								triggers = { ";" },
							},
							git_centers = {
								github = {
									issue = {
										get_kind_name = function(item)
											-- openIssue, reopenedIssue, completedIssue
											-- not_plannedIssue, lockedIssue, duplicateIssue
											return item.locked and "lockedIssue"
												or (item.state_reason or item.state) .. "Issue"
										end,
										configure_score_offset = pr_or_issue_configure_score_offset,
									},
									pull_request = {
										get_kind_name = function(item)
											-- openPR, closedPR, mergedPR, draftPR, lockedPR
											return item.locked and "lockedPR"
												or item.draft and "draftPR"
												or item.merged_at and "mergedPR"
												or item.state .. "PR"
										end,
										configure_score_offset = pr_or_issue_configure_score_offset,
									},
								},
							},
						},
					},
					ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
				},
			},
			keymap = {
				preset = "super-tab",
			},
			signature = { enabled = true },
			completion = {
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
						},
					},
				},
			},
			appearance = {
				nerd_font_variant = "normal",
			},
		},
		---@param opts blink.cmp.Config | { sources: { compat: string[] } }
		config = function(_, opts)
			local blink_cmp_git_kind_name_highlight = {
				Commit = { default = false, fg = "#a6e3a1" },
				Mention = { default = false, fg = "#a6e3a1" },
				openPR = { default = false, fg = "#a6e3a1" },
				openedPR = { default = false, fg = "#a6e3a1" },
				closedPR = { default = false, fg = "#f38ba8" },
				mergedPR = { default = false, fg = "#cba6f7" },
				draftPR = { default = false, fg = "#9399b2" },
				lockedPR = { default = false, fg = "#f5c2e7" },
				openIssue = { default = false, fg = "#a6e3a1" },
				openedIssue = { default = false, fg = "#a6e3a1" },
				reopenedIssue = { default = false, fg = "#a6e3a1" },
				completedIssue = { default = false, fg = "#cba6f7" },
				closedIssue = { default = false, fg = "#cba6f7" },
				not_plannedIssue = { default = false, fg = "#9399b2" },
				duplicateIssue = { default = false, fg = "#9399b2" },
				lockedIssue = { default = false, fg = "#f5c2e7" },
			}
			for kind_name, hl in pairs(blink_cmp_git_kind_name_highlight) do
				vim.api.nvim_set_hl(0, "BlinkCmpGitKind" .. kind_name, hl)
				vim.api.nvim_set_hl(0, "BlinkCmpGitKindIcon" .. kind_name, hl)
				vim.api.nvim_set_hl(0, "BlinkCmpGitLabel" .. kind_name .. "Id", hl)
			end

			local icons = require("custom.icons").kinds
			local extra = {
				Emoji = "󰞅",
				Ripgrep = "󱎸",
			}

			local final_icons = vim.tbl_extend("force", icons, extra)

			opts.appearance = opts.appearance or {}
			opts.appearance.kind_icons = vim.tbl_extend("force", final_icons, opts.appearance.kind_icons or {})

			local blink_cmp_kind_name_highlight = {
				Emoji = { default = false, fg = "#FF9800" },
				Ripgrep = { default = false, fg = "#5D6D7E" },
				Dict = { default = false, fg = "#00A6ED" },
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
