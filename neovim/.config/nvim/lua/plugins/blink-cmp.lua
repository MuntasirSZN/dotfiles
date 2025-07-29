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
	"saghen/blink.cmp",
	version = "*",
	lazy = false,
	dependencies = {
		"saghen/blink.compat",
		"xzbdmw/colorful-menu.nvim",
		-- Snippets
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip",
		-- Completion sources
		"mikavilpas/blink-ripgrep.nvim",
		"moyiz/blink-emoji.nvim",
		{
			"Kaiser-Yang/blink-cmp-git",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{ "disrupted/blink-cmp-conventional-commits" },
		{ "alexandre-abrioux/blink-cmp-npm.nvim" },
		{ "archie-judd/blink-cmp-words" },
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
			},
		},
		snippets = {
			preset = "luasnip",
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
				"git",
				"emoji",
				"ecolog",
				"conventional_commits",
				"npm",
				"dictionary",
			},
			providers = {
				dictionary = {
					name = "blink-cmp-words",
					module = "blink-cmp-words.dictionary",
				},
				npm = {
					name = "npm",
					module = "blink-cmp-npm",
					async = true,
					-- optional - make blink-cmp-npm completions top priority (see `:h blink.cmp`)
					score_offset = 100,
					-- optional - blink-cmp-npm config
					---@module "blink-cmp-npm"
					---@type blink-cmp-npm.Options
					opts = {
						only_semantic_versions = true,
						only_latest_version = false,
					},
				},
				conventional_commits = {
					name = "Conventional Commits",
					module = "blink-cmp-conventional-commits",
					enabled = function()
						return vim.bo.filetype == "gitcommit"
					end,
					---@module 'blink-cmp-conventional-commits'
					---@type blink-cmp-conventional-commits.Options
					opts = {}, -- none so far
				},
				lsp = {
					score_offset = 98,
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
					score_offset = 90,
					---@module "blink-ripgrep"
					---@type blink-ripgrep.Options
					opts = {},
				},
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					async = true,
					score_offset = 91,
					opts = { insert = true }, -- Insert emoji (default) or complete its name
					should_show_items = function()
						return vim.tbl_contains(
							{ "gitcommit", "markdown", "norg", "rmd", "org", "mdx" },
							vim.o.filetype
						)
					end,
				},
				git = {
					module = "blink-cmp-git",
					name = "Git",
					async = true,
					score_offset = 92,
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
						kind_icon = {
							text = function(ctx)
								local icons = require("custom.icons").kinds
								local icon = (icons[ctx.kind] or "󰈚")

								return icon
							end,
						},
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

		local blink_cmp_kind_name_highlight = {
			Emoji = { default = false, fg = "#FF9800" },
			Ripgrep = { default = false, fg = "#5D6D7E" },
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
}
