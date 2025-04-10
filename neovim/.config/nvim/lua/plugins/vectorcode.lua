return {
	"Davidyz/VectorCode",
	version = "*", -- optional, depending on whether you're on nightly or release
	build = "vectorcode", -- optional but recommended if you set `version = "*"`
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "VectorCode",
	config = function()
		require("vectorcode").setup()
	end,
}
