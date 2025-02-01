-- posting.lua
local Popup = require("nui.popup")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local M = {}

-- Function to open `posting` in a terminal inside a popup
function M.open_posting_in_popup()
	local popup = Popup({
		enter = true,
		focusable = true,
		border = {
			style = "rounded",
		},
		position = "45%",
		size = {
			width = "90%",
			height = "90%",
		},
	})

	-- Mount the popup
	popup:mount()

	-- Open a terminal in the popup buffer and run the `posting` command
	vim.fn.termopen("posting", {
		on_exit = function()
			-- Unmount the popup when the process exits
			popup:unmount()
		end,
	})

	-- Set keymaps or autocmds to handle the terminal behavior
	vim.api.nvim_buf_set_keymap(popup.bufnr, "n", "q", "<Cmd>q<CR>", { noremap = true, silent = true })

	-- Unmount the popup when the terminal buffer is closed
	popup:on(event.BufLeave, function()
		popup:unmount()
	end)
end

-- Function to open `posting` in a normal buffer
function M.open_posting_in_buffer()
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(true, false)

	-- Set the buffer as the current buffer
	vim.api.nvim_set_current_buf(buf)

	-- Open a terminal in the buffer and run the `posting` command
	vim.fn.termopen("posting", {
		on_exit = function() end,
	})

	vim.cmd("set number!")

	-- Set keymaps to handle the terminal behavior
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>q<CR>", { noremap = true, silent = true })
end

-- Function to create and show the NUI menu
function M.open_posting_with_menu()
	local menu = Menu({
		position = "50%",
		size = {
			width = 30,
			height = 2,
		},
		border = {
			style = "rounded",
			text = {
				top = "Posting CLI",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		lines = {
			Menu.item("1. Open in popup"),
			Menu.item("2. Open in normal buffer"),
		},
		max_width = 20,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_submit = function(item)
			if item.text == "1. Open in popup" then
				M.open_posting_in_popup()
			elseif item.text == "2. Open in normal buffer" then
				M.open_posting_in_buffer()
			end
		end,
	})

	-- Mount the menu
	menu:mount()
end

return M
