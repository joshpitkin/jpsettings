call plug#begin('~/AppData/Local/nvim/plugged')
" below are some vim plugin for demonstration purpose
Plug 'joshdick/onedark.vim'
Plug 'iCyMind/NeoSolarized'
Plug 'https://github.com/cocopon/iceberg.vim/'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'https://github.com/ap/vim-buftabline'
Plug 'https://github.com/dbeniamine/cheat.sh-vim'
Plug 'APZelos/blamer.nvim'
Plug 'neoclide/coc.nvim'
" Plug 'juanibiapina/vim-lighttree'
call plug#end()

let NERDTreeHijackNetrw=1
" let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='luna'
syntax on
set number
set splitbelow
" set shell=$PROGRAMW6432/Git/bin/bash.exe
set expandtab
set softtabstop=2
set shiftwidth=2
set ignorecase
set smartcase
set hidden
set noswapfile
set backspace=indent,eol,start
set autochdir
colo iceberg
if has("win32")
 let &shell='bash.exe'
 let &shellcmdflag = '-c'
 let &shellredir = '>%s 2>&1'
 set shellquote= shellxescape=
 " set noshelltemp
 set shellxquote=
 let &shellpipe='2>&1| tee'
endif
let mapleader=" "
:tnoremap <Esc> <C-\><C-n>
:nnoremap <SPACE> <Nop>
:nnoremap <C-p> :e .<CR>
:nnoremap <C-q> :bp\|bd #<CR> 
:nnoremap <C-tab> :bn<CR>
:nnoremap <C-S-tab> :bp<CR>
:inoremap <C-tab> <Esc>:bn<CR>i
:inoremap <C-S-tab> <Esc>:bp<CR>i

