set nocompatible               " be iMproved

filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle

call vundle#begin()

Plugin 'gmarik/Vundle'

Plugin 'raymond-w-ko/vim-lua-indent'

Plugin 'scrooloose/nerdtree'

" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

call vundle#end()

" enable syntax highlighting
syntax on

" use incremental search
set incsearch

" enable hidden buffers
set hidden

" use visual bell instead of audio
set visualbell

" intead of failed ask for confirmation
set confirm

" enable line number
set number

" not really sure what this does
set showcmd

" better cmd completion
set wildmenu

" prevent many 'press <Enter> to continue'
set cmdheight=2


" Indentation setting
" tab character is displayed as 3 spaces
set tabstop=3
set shiftwidth=3

" don't expand tabs into spaces
set expandtab
set autoindent
set smartindent


" Key remappings
" map jj to esc
inoremap jj <Esc>

" map Y to yank to end of line
noremap Y y$
