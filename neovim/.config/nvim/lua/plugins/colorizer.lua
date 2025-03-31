return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		filetypes = {
			"*",
			"!Trouble",
			"!alpha",
			"!dashboard",
			"!fzf",
			"!help",
			"!lazy",
			"!mason",
			"!neo-tree",
			"!notify",
			"!snacks_dashboard",
			"!snacks_notif",
			"!snacks_terminal",
			"!snacks_win",
			"!toggleterm",
			"!trouble",
		},
		user_default_options = {
			virtualtext = require("custom.icons").misc.color_text,
			mode = "virtualtext",
			RRGGBBAA = true,
			AARRGGBB = true,
			css = true,
			css_fn = true,
			virtualtext_inline = "before",
			tailwind = true,
			tailwind_opts = {
				update_names = true,
			},
			sass = { enable = true, parsers = { "css" } },
		},
	},
	init = function()
		local c = require("colorizer")
		vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
			callback = function(args)
				if args.event == "InsertEnter" then
					c.detach_from_buffer()
				else
					if not c.is_buffer_attached() then
						c.attach_to_buffer()
					end
				end
			end,
		})
	end,
}
