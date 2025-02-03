require("eza-preview"):setup({
	-- Determines the directory depth level to tree preview (default: 3)
	level = 3,

	-- Whether to follow symlinks when previewing directories (default: false)
	follow_symlinks = true,

	-- Whether to show target file info instead of symlink info (default: false)
	dereference = false,
})

require("starship"):setup()
require("yaziline"):setup()
require("git"):setup()
require("full-border"):setup()
require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})
