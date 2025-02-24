return {
	"folke/snacks.nvim",
	priority = 5000,
	lazy = false,
	config = function()
		local cache = {
			ascii_art = nil,
			last_modified = nil,
		}

		local function get_file_mod_time(filepath)
			local stat = vim.loop.fs_stat(filepath)
			return stat and stat.mtime.sec or nil
		end

		local function header()
			local ascii_path = os.getenv("HOME") .. "/.config/nvim/lua/ascii.txt"
			local current_mod_time = get_file_mod_time(ascii_path)

			-- If cache is empty or file has changed, reload
			if cache.last_modified ~= current_mod_time then
				local command = (vim.uv.os_uname().sysname == "Windows") and "type " .. ascii_path
					or "/bin/cat " .. ascii_path

				cache.ascii_art = vim.fn.system(command)
				cache.last_modified = current_mod_time
			end

			return cache.ascii_art
		end

		local colors = require("catppuccin.palettes").get_palette()

		local SnacksPickerColors = {
			-- Matching and Selection
			SnacksPickerMatch = { fg = colors.peach },
			SnacksPickerSelected = { fg = colors.text, bg = colors.surface1, bold = true },
			-- Prompt highlights
			SnacksPickerInput = { bg = colors.surface1 },
			SnacksPickerInputBorder = { bg = colors.surface1, fg = colors.surface1 },
			SnacksPickerInputTitle = { bg = colors.red, fg = colors.mantle },
			-- Results highlights
			SnacksPickerList = { bg = colors.mantle },
			SnacksPickerListBorder = { bg = colors.mantle, fg = colors.mantle },
			SnacksPickerListTitle = { fg = colors.overlay2 },
			-- Preview highlights
			SnacksPickerPreview = { bg = colors.mantle },
			SnacksPickerPreviewBorder = { bg = colors.mantle, fg = colors.mantle },
			SnacksPickerPreviewTitle = { bg = colors.green, fg = colors.crust },
		}

		-- Apply highlights
		for highlight_group, color_settings in pairs(SnacksPickerColors) do
			vim.api.nvim_set_hl(0, highlight_group, color_settings)
		end

    -- stylua: ignore
    ---@type snacks.Config
    local opts = {
      animate = { enabled = true },
      bigfile = { enabled = true },
      image = {
        enabled = true,
        doc = {
          inline = false,
          float = false,
        },
      },
      indent = {
        enabled = true,
        scope = { treesitter = { enabled = true } },
      },
      scope = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
      },
      scroll = { enabled = true },
      words = { enabled = true },
      quickfile = { enabled = true },
      spell = { enabled = true },
      picker = {
        sources = {
          select = {
            layout = {
              preset = "telescope-custom-select",
            },
          },
        },
        enabled = true,
        matcher = {
          frecency = true,
        },
        prompt = " ",
        layout = {
          preset = "telescope-custom",
        },
        layouts = {
          ["telescope-custom-select"] = {
            reverse = false,
            layout = {
              box = "horizontal",
              backdrop = false,
              width = 0.5,
              height = 2,
              border = "none",
              {
                box = "vertical",
                { win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
                {
                  win = "list",
                  title = " Results ",
                  title_pos = "center",
                  border = "rounded",
                  height = 30
                },
              },
            },
          },
          ["telescope-custom"] = {
            reverse = false,
            layout = {
              box = "horizontal",
              backdrop = false,
              width = 0.8,
              height = 0.9,
              border = "none",
              {
                box = "vertical",
                { win = "input", height = 1,          border = "rounded",   title = "{title} {live} {flags}", title_pos = "center" },
                { win = "list",  title = " Results ", title_pos = "center", border = "rounded" },
              },
              {
                win = "preview",
                title = "{preview:Preview}",
                width = 0.53,
                border = "rounded",
                title_pos = "center",
              },
            },
          },
        },
      },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua find_nvim_files()",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = header()
        },
      },
    }
		require("snacks").setup(opts)
		_G.find_nvim_files = function()
			local picker = require("snacks.picker")
			picker.pick({
				source = "files",
				title = " Neovim Config",
				cwd = "~/.config/nvim", -- Set the directory to search in
				hidden = true, -- Show hidden files, useful in config directories
			})
		end

		local map = vim.keymap.set

		if vim.fn.executable("lazygit") == 1 then
			map("n", "<leader>gg", function()
				Snacks.lazygit()
			end, { desc = "Lazygit (Root Dir)" })
			map("n", "<leader>gG", function()
				Snacks.lazygit()
			end, { desc = "Lazygit (cwd)" })
			map("n", "<leader>gf", function()
				Snacks.lazygit.log_file()
			end, { desc = "Lazygit Current File History" })
			map("n", "<leader>gl", function()
				Snacks.lazygit.log()
			end, { desc = "Lazygit Log" })
			map("n", "<leader>gL", function()
				Snacks.lazygit.log()
			end, { desc = "Lazygit Log (cwd)" })
			map({ "n", "x" }, "<leader>gY", function()
				Snacks.gitbrowse({
					open = function(url)
						vim.fn.setreg("+", url)
					end,
					notify = true,
				})
			end, { desc = "Git Browse (copy)" })
		end
	end,
	keys = {
		{
			"<leader>se",
			function()
				if vim.fn.executable("cliphist") then
					Snacks.picker.cliphist()
				else
					vim.notify("cliphist not found", "warn", { title = "Snacks" })
				end
			end,
			desc = "Cliphist",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Goto Declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep (Root Dir)",
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader><space>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files (Root Dir)",
		},
		{
			"<leader>n",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		-- find
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fB",
			function()
				Snacks.picker.buffers({ hidden = true, nofile = true })
			end,
			desc = "Buffers (all)",
		},
		{
			"<leader>fc",
			function()
				find_nvim_files()
			end,
			desc = "Find Config File",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files (Root Dir)",
		},
		{
			"<leader>fF",
			function()
				Snacks.picker.files({ cwd = vim.fn.getcwd() })
			end,
			desc = "Find Files (cwd)",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Find Files (git-files)",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent",
		},
		{
			"<leader>fR",
			function()
				Snacks.picker.recent({ filter = { cwd = true } })
			end,
			desc = "Recent (cwd)",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		-- git
		{
			"<leader>gc",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (hunks)",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Git Stash",
		},
		-- Grep
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sB",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep Open Buffers",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep (Root Dir)",
		},
		{
			"<leader>sG",
			function()
				Snacks.picker.grep({ cwd = vim.fn.getcwd() })
			end,
			desc = "Grep (cwd)",
		},
		{
			"<leader>sp",
			function()
				Snacks.picker.lazy()
			end,
			desc = "Search for Plugin Spec",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Visual selection or word (Root Dir)",
			mode = { "n", "x" },
		},
		{
			"<leader>sW",
			function()
				Snacks.picker.grep_word({ cwd = vim.fn.getcwd() })
			end,
			desc = "Visual selection or word (cwd)",
			mode = { "n", "x" },
		},
		-- search
		{
			'<leader>s"',
			function()
				Snacks.picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>s/",
			function()
				Snacks.picker.search_history()
			end,
			desc = "Search History",
		},
		{
			"<leader>sa",
			function()
				Snacks.picker.autocmds()
			end,
			desc = "Autocmds",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>sC",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>sD",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Buffer Diagnostics",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>sH",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Highlights",
		},
		{
			"<leader>si",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icons",
		},
		{
			"<leader>sj",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.loclist()
			end,
			desc = "Location List",
		},
		{
			"<leader>sM",
			function()
				Snacks.picker.man()
			end,
			desc = "Man Pages",
		},
		{
			"<leader>sm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>sq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>su",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undotree",
		},
		-- ui
		{
			"<leader>uC",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorschemes",
		},
		{
			"<leader>snn",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>Z",
			function()
				Snacks.zen.zoom()
			end,
			desc = "Toggle Zoom",
		},
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git Blame Line",
		},
		{
			"<leader>cT",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Terminal (Bottom)",
		},
		{
			"<c-_>",
			function()
				Snacks.terminal()
			end,
			desc = "which_key_ignore",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
		{
			"<leader>N",
			desc = "Neovim News",
			function()
				Snacks.win({
					file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
					width = 0.6,
					height = 0.6,
					wo = {
						spell = false,
						wrap = false,
						signcolumn = "yes",
						statuscolumn = " ",
						conceallevel = 3,
					},
				})
			end,
		},
	},
}
