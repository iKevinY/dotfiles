" Vim Configuration, heavily inspired by @skwp's .vimrc
set nocompatible

" ===== Pathogen Initialization =====
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
filetype plugin indent on

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

" Disable swap files
set noswapfile
set nobackup
set nowb

" Indentation
set autoindent
set smartindent
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
nnoremap <leader>w <C-w>v<C-w>l

" Toggle fold
nnoremap <leader>f za
vnoremap <leader>f za


" Swap semicolon and colon
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Saner wrapped-line navigation
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j

" Magic regex searches
nnoremap / /\v
vnoremap / /\v

" Saner split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Next/previous buffer
nnoremap <Leader>[ :bp<CR>
nnoremap <Leader>] :bn<CR>

" ===== ~/.vimrc.local =====
let $LOCALFILE=expand("~/.vimrc.local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif

" ===== CtrlP =====
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" ===== vim-airline =====
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" ===== vim-better-whitespace =====
autocmd VimEnter * DisableWhitespace
autocmd VimEnter * EnableWhitespace

" ===== vim-expand-region =====
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" ===== vim-startify =====
let g:ctrlp_reuse_window = 'startify'

let g:startify_files_number = 5
let g:startify_enable_special = 0
let g:startify_custom_indices = map(range(1, 9) + [0] + range(10,100), 'string(v:val)')

let g:startify_list_order = ['files', 'dir', 'bookmarks']
let g:startify_bookmarks = [{'v': '~/.vimrc'}]

let g:startify_custom_header =
    \ map(split(system('vim --version | head -n1 | sed -e "s/ ([^()]*)//"'), '\n'), '"   ". v:val') + ['']
