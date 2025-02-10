let g:airline_powerline_fonts = 1
syntax on
set number
set termguicolors
set encoding=UTF-8
colorscheme catppuccin_mocha

let g:mapleader = " "
let g:maplocalleader = " "

set cursorline

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
Jetpack 'junegunn/fzf'
Jetpack 'junegunn/fzf.vim'

" Core UI Enhancements
Jetpack 'vim-airline/vim-airline'
Jetpack 'vim-airline/vim-airline-themes'
Jetpack 'catppuccin/vim'

" Keybinding Helper
Jetpack 'liuchengxu/vim-which-key', {'on': ['WhichKey']}

" Sensible Defaults
Jetpack 'tpope/vim-sensible'

" Navigation and Editing Enhancements
Jetpack 'pechorin/any-jump.vim', {'on': ['AnyJump']}
Jetpack 'justinmk/vim-sneak', {'on': ['<Plug>Sneak_s', '<Plug>Sneak_S']}
Jetpack 'tpope/vim-surround', {'keys': ['cs', 'ds', 'ys']}
Jetpack 'tpope/vim-fugitive', {'on': ['Gstatus', 'Gcommit', 'Gpush']}
Jetpack 'mhinz/vim-signify', {'on': ['SignifyToggle']}
Jetpack 'LunarWatcher/auto-pairs'
Jetpack 'mhinz/vim-startify'
Jetpack 'preservim/nerdtree'
Jetpack 'preservim/nerdcommenter'
Jetpack 'nathanaelkane/vim-indent-guides'
Jetpack 'sheerun/vim-polyglot'
Jetpack 'mbbill/undotree'
Jetpack 'ryanoasis/vim-devicons'
call jetpack#end()
