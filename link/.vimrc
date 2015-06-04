" Vim Configuration, heavily inspired by @skwp's .vimrc

" ===== Vundle Initialization =====
set nocompatible

filetype on                " fixes exit code on OS X
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'kien/ctrlp.vim'

call vundle#end()
filetype plugin indent on

" ===== General Configuration =====
set number                           " Enable line numbers
set backspace=indent,eol,start       " Allow backspaces in insert mode
set history=512                      " Store :cmdline history
set showmode                         " Show current mode at bottom of screen
set gcr=a:blinkon0                   " Disable cursor blink
set visualbell                       " Disable audible bell
set autoread                         " Reload files changed outside of Vim
set hidden                           " Allow buffers to exist in background
set ffs=unix,dos,mac                 " Use Unix as standard file type
set magic                            " Improve regular expressions
set showmatch                        " Show matching brackets
set mat=2                            " Blink matching brackets for 0.2 seconds
set nowrap                           " Disable line wrapping
set list listchars=tab:\ \ ,trail:·  " Visual tabs and trailing spaces
set linebreak
set encoding=utf8
set ruler

syntax on                            " Enable syntax highlighting
colorscheme tomorrow-night-eighties  " Pick color scheme file


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
