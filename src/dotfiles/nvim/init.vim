" Look and Feel -----------------------------------------------------
autocmd FileType markdown setlocal spell
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
colorscheme onedark
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
set binary                       " Handle files with mixed line endings better
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
set expandtab                    " Turn tabs to spaces
set listchars=space:·,tab:=>     " Display special characters (whitespace)
set list
set shiftwidth=4                 " Set auto indent size to 4
set softtabstop=4                " Set insert mode tab size to 4
set tabstop=4                    " Set tab size to 4

" Plugins -----------------------------------------------------
lua << EOF
require('packer').startup(function()
    use 'wbthomason/packer.nvim'  -- Packer can manage itself

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    require'nvim-treesitter.configs'.setup {
        -- A list of parser names
        ensure_installed = {
            "apex",
            "bash",
            "c",
            "go",
            "java",
            "javascript",
            "json",
            "json5",
            "lua",
            "markdown",
            "php",
            "python",
            "query",
            "regex",
            "ruby",
            "rust",
            "swift",
            "typescript",
            "vim",
            "vimdoc",
            "yaml"
        },
        highlight = {
            enable = true
        }
    }

    use { "catppuccin/nvim", as = "catppuccin" }
    -- catppuccin-latte
    -- catppuccin-frappe
    -- catppuccin-macchiato
    -- catppuccin-mocha

    use 'navarasu/onedark.nvim'
    require('onedark').setup {
        -- Main options --
        style = 'darker', -- Default theme style.
        -- dark (default)
        -- darker
        -- cool
        -- deep
        -- warm
        -- warmer
        -- light
    }

    use { "scottmckendry/cyberdream.nvim" }
    use "EdenEast/nightfox.nvim"
    -- Carbonfox
    -- Dayfox
    -- Dawnfox
    -- Duskfox
    -- Nordfox
    -- Terafox
    use ({ 'projekt0n/github-nvim-theme' })
    -- github_dark
    -- github_light
    -- github_dark_dimmed
    -- github_default
    -- github_dark_high_contrast
    -- github_light_high_contrast
    use({ "neanias/everforest-nvim" })
end)
EOF
