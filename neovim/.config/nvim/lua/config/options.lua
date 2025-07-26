-- options.lua

-- Better startup time
vim.loader.enable()

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
vim.g.loaded_perl_provider = 0

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Editor settings
local opt = vim.opt

opt.termguicolors = true
opt.autowrite = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.formatexpr = "v:lua.require'custom.format'.formatexpr()"
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.laststatus = 3
opt.linebreak = true
opt.list = true
opt.mouse = "a"
opt.mousemoveevent = true
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = false -- Overridden by second config
opt.ruler = false
opt.scrolloff = 4
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.spell = true
opt.spelllang = { "en" }
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false

if vim.fn.has("nvim-0.11") == 1 then
	opt.smoothscroll = true
	opt.foldexpr = "v:lua.vim.lsp.formatexpr({ timeout_ms = 3000 })"
	opt.foldmethod = "expr"
	opt.foldtext = ""
else
	opt.foldmethod = "indent"
	opt.foldtext = "v:lua.require'custom.ui'.foldtext()"
end

-- Diagnostic configuration
vim.diagnostic.config({
	underline = true,
	update_in_insert = true,
	document_highlight = {
		enabled = true,
	},
	capabilities = {
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = require("custom.icons").diagnostics.Error,
			[vim.diagnostic.severity.WARN] = require("custom.icons").diagnostics.Warn,
			[vim.diagnostic.severity.INFO] = require("custom.icons").diagnostics.Info,
			[vim.diagnostic.severity.HINT] = require("custom.icons").diagnostics.Hint,
		},
	},
	severity_sort = true,
})

-- Lazy require helper
_G.lazy_require = function(require_path)
	return setmetatable({}, {
		__index = function(_, key)
			return require(require_path)[key]
		end,
		__newindex = function(_, key, value)
			require(require_path)[key] = value
		end,
	})
end

-- Hyprland filetype
vim.filetype.add({
	pattern = {
		[".*/hypr/.*%.conf"] = "hyprlang",
	},
})
