return {
	"kevinhwang91/nvim-ufo",
	event = {
		"LspAttach",
	},
	lazy = true,
	dependencies = {
		"kevinhwang91/promise-async",
		{
			"luukvbaal/statuscol.nvim",
			config = function()
				local builtin = require("statuscol.builtin")
				require("statuscol").setup({
					relculright = true,
					ft_ignore = {
						"Trouble",
						"alpha",
						"dashboard",
						"fzf",
						"help",
						"lazy",
						"mason",
						"neo-tree",
						"notify",
						"snacks_dashboard",
						"snacks_notif",
						"snacks_terminal",
						"snacks_win",
						"toggleterm",
						"trouble",
					},
					segments = {
						{ text = { "%s" }, click = "v:lua.ScSa" },
						{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
						{ text = { " ", builtin.foldfunc, " " }, click = "v:lua.ScFa" },
					},
				})
			end,
		},
	},
	opts = {
		open_fold_hl_timeout = 400,
		close_fold_kinds_for_fts = { "imports", "comment" },
		preview = {
			win_config = {
				border = { "", "─", "", "", "", "─", "", "" },
				winhighlight = "Normal:Folded",
				winblend = 0,
			},
			mappings = {
				scrollU = "<C-u>",
				scrollD = "<C-d>",
				jumpTop = "[",
				jumpBot = "]",
			},
		},
	},
	config = function(_, opts)
		-- Set up excluded filetypes
		local excluded_filetypes = {
			"trouble",
			"alpha",
			"dashboard",
			"fzf",
			"help",
			"lazy",
			"mason",
			"neo-tree",
			"notify",
			"snacks_dashboard",
			"snacks_notif",
			"snacks_terminal",
			"snacks_win",
			"toggleterm",
			"BlinkCmpMenu",
		}

		-- Create a lookup table for faster checking
		local excluded_ft_lookup = {}
		for _, ft in ipairs(excluded_filetypes) do
			excluded_ft_lookup[ft] = true
		end

		-- Set up excluded buffer types
		local excluded_buftypes = {
			["nofile"] = true,
			["terminal"] = true,
		}

		-- Set default options for supported filetypes and buftypes
		local function set_folding_options()
			local current_ft = vim.bo.filetype
			local current_bt = vim.bo.buftype

			-- Disable folding for excluded filetypes or buftypes
			if excluded_ft_lookup[current_ft] or excluded_buftypes[current_bt] then
				vim.opt_local.foldcolumn = "0"
				vim.opt_local.foldenable = false
				require("ufo").detach()
			else
				vim.opt_local.foldcolumn = "1"
				vim.opt_local.foldenable = true
				vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
				vim.o.foldlevel = 99
				vim.o.foldlevelstart = 99
			end
		end

		-- Set up autocommands for handling filetypes and buftypes
		vim.api.nvim_create_autocmd({ "FileType", "BufAdd", "BufEnter" }, {
			pattern = "*",
			callback = set_folding_options,
		})

		local handler = function(virtText, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local totalLines = vim.api.nvim_buf_line_count(0)
			local foldedLines = endLnum - lnum
			local suffix = (" 󰁂 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, { chunkText, hlGroup })
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end
			local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
			suffix = (" "):rep(rAlignAppndx) .. suffix
			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end

		opts["fold_virt_text_handler"] = handler
		require("ufo").setup(opts)

		-- Keymaps
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end)
	end,
}
