return {
	"cordx56/rustowl",
	build = "mise up cargo:rustowl",
	lazy = false,
	enabled = false,
	config = function()
		require("rustowl").setup({
			highlight_style = "underline",
		})
	end,
}
