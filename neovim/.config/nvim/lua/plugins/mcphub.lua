return {
	"ravitemer/mcphub.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
	},
	cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
	build = "bundled_build.lua", -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
	config = function()
		require("mcphub").setup({
			use_bundled_binary = true, -- Use the bundled MCP binary
			auto_approve = true,
		})
	end,
}
