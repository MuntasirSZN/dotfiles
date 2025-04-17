return {
	"nvzone/menu",
	event = "VeryLazy",
	lazy = true,
	config = function()
		vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
			require("menu.utils").delete_old_menus()

			vim.cmd.exec('"normal! \\<RightMouse>"')

			-- clicked buf
			local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
			local options = vim.bo[buf].ft == "neo-tree" and "neo-tree" or "default"

			require("menu").open(options, { mouse = true })
		end, {})
	end,
}
