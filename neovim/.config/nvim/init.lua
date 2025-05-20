if vim.env.PROF then
	local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
	vim.opt.rtp:append(snacks)
	require("snacks.profiler").startup({
		startup = {
			event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
		},
	})
end

if vim.g.neovide then
	-- text
	vim.o.guifont = "FiraCode Nerd Font:h12.5"
	vim.g.neovide_text_gamma = 0.8
	vim.g.neovide_text_contrast = 0.9
	vim.g.neovide_font_style = "Retina"

	-- window padding
	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0

	-- border
	vim.g.neovide_show_border = false

	-- remember window size
	vim.g.neovide_remember_window_size = true
	vim.api.nvim_set_keymap("n", "<F11>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})
	vim.g.neovide_floating_blur_amount_x = 3.0
	vim.g.neovide_floating_blur_amount_y = 3.0
	vim.g.neovide_scroll_animation_far_lines = 1
	vim.g.neovide_input_macos_option_key_is_meta = "only_left"

	vim.g.neovide_cursor_smooth_blink = true
	vim.opt.guicursor = {
		"i-ci-c:ver25",
		"n-sm:block",
		"r-cr-o-v:hor10",
		"a:blinkwait200-blinkoff800-blinkon1000",
	}

	vim.g.neovide_cursor_animation_length = 0.03
	vim.g.neovide_cursor_trail_size = 1.0 -- 0-1, long trail
	vim.g.neovide_cursor_vfx_mode = "railgun" -- railgun|torpedo|pixiedust|sonicboom|ripple|wireframe

	vim.g.neovide_cursor_vfx_particle_lifetime = 1.3
	vim.g.neovide_cursor_vfx_particle_density = 0.7
	vim.g.neovide_cursor_vfx_particle_speed = 20
end

require("config.options")
require("config.lazy")
require("config.autocmds")
require("config.keymaps")
