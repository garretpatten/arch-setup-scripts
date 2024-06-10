" Look and Feel -----------------------------------------------------
autocmd FileType markdown setlocal spell
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
colorscheme slate
set cc=80
set cursorline
set foldenable
set guifont=Fira\ Code:h12
set nowrap
set re=0
set showcmd
set showmatch
set showmode
set wildmode=longest,list
syntax on

" Files -----------------------------------------------------
filetype on
filetype plugin on
filetype indent on

" Misc -----------------------------------------------------
let g:loaded_perl_provider=0
set backupdir=~/.cache/vim
set clipboard=unnamedplus
set encoding=utf-8
set nocompatible

" Navigation -----------------------------------------------------
set relativenumber

" Searching -----------------------------------------------------
set hlsearch
set ignorecase
set showmatch
set smartcase

" Whitespace -----------------------------------------------------
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Plugins -----------------------------------------------------
