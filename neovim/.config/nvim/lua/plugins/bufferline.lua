return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	lazy = true,
	keys = {
		{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
		{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
		{ "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
		{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
		{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
		{ "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
	},
	opts = {
		options = {
			color_icons = true, -- Enable/disable color icons,
			show_buffer_icons = true, -- Enable/disable buffer icons
			show_buffer_close_icons = true, -- Enable/disable close icons on buffers
			show_close_icon = true,
			show_tab_indicators = true,
			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},
      -- stylua: ignore
      close_command = function(n) Snacks.bufdelete(n) end,
      -- stylua: ignore
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
			diagnostics = "nvim_lsp", -- Show LSP diagnostics in the bufferline
			always_show_bufferline = false, -- Only show bufferline when needed
			diagnostics_indicator = function(_, _, diag)
				local icons = require("custom.icons").diagnostics
				local ret = (diag.error and icons.Error .. diag.error .. " " or "")
					.. (diag.warning and icons.Warn .. diag.warning or "")
				return vim.trim(ret)
			end,
			---@param opts bufferline.IconFetcherOpts
			get_element_icon = function(opts)
				return require("custom.icons").ft[opts.filetype]
			end,
			offsets = {
				{
					filetype = "snacks_layout_box",
				},
				{
					filetype = "neo-tree", -- File Explorer
					text = "  File Explorer",
					highlight = "Directory",
					text_align = "left",
					separator = true,
				},
			},
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)
		-- Fix bufferline when restoring a session
		vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
			callback = function()
				vim.schedule(function()
					pcall(nvim_bufferline)
				end)
			end,
		})
	end,
}
