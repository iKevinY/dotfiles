" Vim Configuration, heavily inspired by @skwp's .vimrc
set nocompatible

" ===== Pathogen Initialization =====
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
filetype plugin indent on

" ===== General Configuration =====
set number                           " Enable line numbers
set backspace=indent,eol,start       " Allow backspaces in insert mode
set history=512                      " Store :cmdline history
set noshowmode                       " Hide mode (handled by vim-airline)
set scrolloff=3                      " Keep 3 lines above/below cursor
set gcr=a:blinkon0                   " Disable cursor blink
set visualbell                       " Disable audible bell
set autoread                         " Reload files changed outside of Vim
set hidden                           " Allow buffers to exist in background
set cursorline                       " Highlight current line
set ffs=unix,dos,mac                 " Use Unix as standard file type
set magic                            " Improve regular expressions
set showmatch                        " Show matching brackets
set mat=1                            " Blink matching brackets for 0.1s
set confirm                          " Prompt to save changed files
set linebreak                        " Break at breakable characters on wrap
set encoding=utf-8                   " Set file encoding
syntax on                            " Enable syntax highlighting
colorscheme tomorrow-night-eighties  " Pick color scheme

" ===== Disable swap files =====
set noswapfile
set nobackup
set nowb

" ===== Indentation =====
set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" ===== Search =====
set incsearch        " Find matches while searching
set ignorecase       " Ignore case when searching...
set smartcase        " ...unless we type a capital
set hlsearch         " Highlight searches by default

" ===== Trailing Whitespace =====
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" ===== vim-airline =====
set laststatus=2
let g:airline_powerline_fonts = 1

" ===== vim-expand-region =====
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
