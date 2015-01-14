set nocompatible               " be iMproved

filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle

call vundle#begin()

Plugin 'gmarik/Vundle'

Plugin 'scrooloose/nerdtree'

Plugin 'altercation/vim-colors-solarized'

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

" enable hidden buffers
set hidden

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

" I hate line wrapping
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

" Faster up/down navigation
nnoremap J 5j
nnoremap K 5k
xnoremap J 5j
xnoremap K 5k

" map Y to yank to end of line
nnoremap Y y$

" Faster split navigation
nnoremap gh <C-w>h
nnoremap gj <C-w>j
nnoremap gk <C-w>k
nnoremap gl <C-w>l

" Faster resize
nnoremap gL 4<C-w>+
nnoremap gH 4<C-w>-

" Color scheme
colorscheme slate

" NERDTree shortcut
nnoremap <C-n> :NERDTreeToggle<CR>

" Save as root
let s:save_as_root=0
command WW
   \ let s:save_as_root=1 |
   \ w !sudo tee %

autocmd! FileChangedShell * 
   \ if s:save_as_root == 1 |
   \    let v:fcs_choice="reload" |
   \    let s:save_as_root=0 |
   \ endif
