require("eza-preview"):setup({
	-- Determines the directory depth level to tree preview (default: 3)
	level = 3,

	-- Whether to follow symlinks when previewing directories (default: false)
	follow_symlinks = true,

	-- Whether to show target file info instead of symlink info (default: false)
	dereference = false,
})

require("starship"):setup()
-- require("yaziline"):setup()
require("git"):setup()
require("full-border"):setup()
require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})

local catppuccin_theme = require("yatline-catppuccin"):setup("mocha")

require("yatline"):setup({
	theme = catppuccin_theme,
	show_background = true,

	header_line = {
		left = {
			section_a = {
			},
			section_b = {
			},
			section_c = {
			}
		},
		right = {
			section_a = {
			},
			section_b = {
			},
			section_c = {
			}
		}
	},
	status_line = {
		left = {
			section_a = {
        			{type = "string", custom = false, name = "tab_mode"},
			},
			section_b = {
        			{type = "string", custom = false, name = "hovered_size"},
			},
			section_c = {
        			{type = "string", custom = false, name = "hovered_name"},
			}
		},
		right = {
			section_a = {
        			{type = "string", custom = false, name = "cursor_position"},
			},
			section_b = {
        			{type = "string", custom = false, name = "cursor_percentage"},
			},
			section_c = {
        			{type = "coloreds", custom = false, name = "permissions"},
			}
		}
	},
})
