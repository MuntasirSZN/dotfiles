return {
	"OXY2DEV/markview.nvim",
	lazy = false, -- Recommended
	keys = {
		{
			"<leader>m",
			function() end,
			desc = "Markdown",
		},
		{
			"<leader>mc",
			function()
				vim.cmd("Checkbox")
			end,
			desc = "Checkbox",
		},
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
		"saghen/blink.cmp",
	},
	config = function()
		local function conceal_tag(icon, hl_group)
			return {
				on_node = { hl_group = hl_group },
				on_closing_tag = { conceal = "" },
				on_opening_tag = {
					conceal = "",
					virt_text_pos = "inline",
					virt_text = { { icon .. " ", hl_group } },
				},
			}
		end

		require("markview").setup({
			preview = {
				filetypes = {
					"yaml",
					"latex",
					"typst",
					"markdown",
					"norg",
					"rmd",
					"org",
					"mdx",
					"codecompanion",
					"octo",
				},
				ignore_buftypes = {},
			},
			html = {
				container_elements = {
					["^buf$"] = conceal_tag("", "CodeCompanionChatVariable"),
					["^file$"] = conceal_tag("", "CodeCompanionChatVariable"),
					["^help$"] = conceal_tag("󰘥", "CodeCompanionChatVariable"),
					["^image$"] = conceal_tag("", "CodeCompanionChatVariable"),
					["^symbols$"] = conceal_tag("", "CodeCompanionChatVariable"),
					["^url$"] = conceal_tag("󰖟", "CodeCompanionChatVariable"),
					["^var$"] = conceal_tag("", "CodeCompanionChatVariable"),
					["^tool$"] = conceal_tag("", "CodeCompanionChatTool"),
					["^user_prompt$"] = conceal_tag("", "CodeCompanionChatTool"),
					["^group$"] = conceal_tag("", "CodeCompanionChatToolGroup"),
				},
			},
			markdown = {
				list_items = {
					shift_width = function(buffer, item)
						--- Reduces the `indent` by 1 level.
						---
						---         indent                      1
						--- ------------------------- = 1 ÷ --------- = new_indent
						--- indent * (1 / new_indent)       new_indent
						---
						local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)

						return item.indent * (1 / (parent_indnet * 2))
					end,
					marker_minus = {
						add_padding = function(_, item)
							return item.indent > 1
						end,
					},
				},
			},
			icon_provider = "devicons",
		})

		vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged" }, {
			pattern = { "octo://*", "octo" },
			callback = function()
				vim.cmd("Markview attach")
			end,
		})

		require("markview.extras.editor").setup()
		require("markview.extras.checkboxes").setup()
		require("markview.extras.headings").setup()
	end,
}
