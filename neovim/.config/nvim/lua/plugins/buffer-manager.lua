return {
	"j-morano/buffer_manager.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local map = vim.keymap.set

		require("buffer_manager").setup({
			select_menu_item_commands = {
				v = {
					key = "<C-v>",
					command = "vsplit",
				},
				h = {
					key = "<C-h>",
					command = "split",
				},
			},
			focus_alternate_buffer = false,
			short_file_names = true,
			short_term_names = true,
			loop_nav = false,
			highlight = "Normal:BufferManagerBorder",
			win_extra_options = {
				winhighlight = "Normal:BufferManagerNormal",
			},
		})

		local bmui = require("buffer_manager.ui")

		local keys = "1234567890"
		for i = 1, #keys do
			local key = keys:sub(i, i)
			map("n", string.format("<leader>b%s", key), function()
				bmui.nav_file(i)
			end, { noremap = true, desc = string.format("Navigate To Buffer %s", key) })
		end
		-- Just the menu
		map({ "t", "n" }, "<leader>bm", bmui.toggle_quick_menu, { noremap = true, desc = "Buffer Manager Menu" })
		-- Open menu and search
		map({ "t", "n" }, "<leader>bs", function()
			bmui.toggle_quick_menu()
			-- wait for the menu to open
			vim.defer_fn(function()
				vim.fn.feedkeys("/")
			end, 50)
		end, { noremap = true, desc = "Buffer Manager Menu And Search" })
		-- Next/Prev
		map("n", "<leader>bn", bmui.nav_next, { noremap = true, desc = "Navigate To Next Buffer" })
		map("n", "<leader>bu", bmui.nav_prev, { noremap = true, desc = "Navigate To Previous Buffer" })
	end,
}
