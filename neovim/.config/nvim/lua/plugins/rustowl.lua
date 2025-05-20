return {
	"cordx56/rustowl",
	version = "*",
	build = "cargo install-update rustowl",
	lazy = false,
	config = function()
		require("rustowl").setup()
	end,
}
