" Vim Configuration, heavily inspired by @skwp's .vimrc
set nocompatible

" ===== vim-plug Initialization =====
call plug#begin('~/.vim/plugins')
Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'justinmk/vim-sneak'
Plug 'ntpeters/vim-better-whitespace'
Plug 'plasticboy/vim-markdown'
Plug 'reedes/vim-colors-pencil'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'Valloric/YouCompleteMe'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" ===== General Configuration =====
syntax on                            " Enable syntax highlighting
colorscheme tomorrow-night-eighties  " Pick color scheme
set guifont=Source\ Code\ Pro:h14    " Pick font (for MacVim)
set relativenumber                   " Enable relative line numbers
set number                           " Use hybrid line numbers instead
set backspace=indent,eol,start       " Allow backspaces in insert mode
set history=512                      " Store :cmdline history
set noshowmode                       " Hide mode (handled by plugins)
set mouse=a                          " Enable mouse in all modes
set clipboard=unnamed                " Sync unnamed register with clipboard
set scrolloff=3                      " Keep 3 lines above/below cursor
set guicursor=a:blinkon0             " Use block cursor in all modes...
set guicursor+=i:ver25-blinkon0      " ...except for in insert mode
set guioptions-=rL                   " Remove scroll bars
set visualbell                       " Disable audible bell
set autoread                         " Reload files changed outside of Vim
set hidden                           " Allow buffers to exist in background
set cursorline                       " Highlight current line
set fileformats=unix,dos,mac         " Use Unix as standard file type
set magic                            " Improve regular expressions
set showmatch                        " Show matching brackets
set matchtime=1                      " Blink matching brackets for 0.1s
set confirm                          " Prompt to save changed files
set linebreak                        " Break at breakable characters on wrap
set encoding=utf-8                   " Set file encoding
set updatetime=500                   " Decrease update time to 500ms
set splitbelow                       " Open new vertical panes below
set splitright                       " Open new horizontal panes to the right
set diffopt+=vertical                " Use vertical diffs by default
set breakindent                      " Visually indent wrapped lines

" Disable swap files
set noswapfile
set nobackup
set nowb

" Indentation
set autoindent
set nosmartindent
set smarttab
set shiftwidth=4
set tabstop=2
set expandtab
filetype plugin on
filetype indent on

" Search
set incsearch                        " Find matches while searching
set ignorecase                       " Ignore case when searching...
set smartcase                        " ...unless we type a capital
set hlsearch                         " Highlight searches by default

" Use very magic mode while searching
nnoremap / /\v
vnoremap / /\v

" ===== Key Bindings =====
let mapleader = ","                  " Remap leader key to comma

" Clear current search
nnoremap <leader><space> :noh<cr>

" Open a new vertical split and switch to it
nnoremap <leader>n <C-w>v<C-w>l

" Close the current buffer
nnoremap <leader>w :bd<cr>

" Toggle fold
nnoremap <leader>f za
vnoremap <leader>f za

" Saner wrapped-line navigation
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j

" Magic regex searches
nnoremap / /\v
vnoremap / /\v

" Delete one word backwards (insert and command-line mode)
noremap! <A-BS> <C-W>

" Saner split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Next/previous buffer
nnoremap <C-S-Tab> :bp<CR>
nnoremap <C-Tab>   :bn<CR>
nnoremap <Leader>[ :bp<CR>
nnoremap <Leader>] :bn<CR>

" ===== ~/.vimrc.local =====
let $LOCALFILE=expand("~/.vimrc.local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif

" ===== CtrlP =====
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" ===== goyo / limelight =====
let g:seoul256_background = 236
set background=dark

function! s:goyo_enter()
    Limelight
    colorscheme seoul256
    set guifont=Cousine:h22
    set linespace=8
    set scrolloff=99
endfunction

function! s:goyo_leave()
    Limelight!
    colorscheme tomorrow-night-eighties
    set guifont=Source\ Code\ Pro:h14
    set linespace=0
    set scrolloff=3
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" ===== vim-airline =====
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_tab_type = 0

" ===== vim-expand-region =====
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" ===== vim-markdown =====
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0

" ===== YouCompleteMe =====
nnoremap <C-]> :YcmCompleter GoTo<CR>
