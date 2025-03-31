return {
	"nvzone/menu",
	event = "VeryLazy",
	lazy = true,
	config = function()
		vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
			vim.cmd.exec('"normal! \\<RightMouse>"')

			local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
			require("menu").open(options, { mouse = true })
		end, {})
	end,
}
