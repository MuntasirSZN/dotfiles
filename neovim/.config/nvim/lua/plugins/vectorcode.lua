return {
	"Davidyz/VectorCode",
	version = "*",
	build = "mise up vectorcode",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "VectorCode",
	config = function()
		require("vectorcode").setup()
	end,
}
