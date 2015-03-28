set nocompatible               " be iMproved

filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle

call vundle#begin()

Plugin 'gmarik/Vundle'

Plugin 'scrooloose/nerdtree'

Plugin 'scrooloose/syntastic'

Plugin 'epeli/slimux'

" PluginList: list configured plugins
" PluginInstall: Installs and updates plugins
" PluginSearch: searches for plugin
" PluginClean: remove plugins
" PluginUpdate: updates plugins

call vundle#end()

" enable syntax highlighting
syntax enable

" intead of failed ask for confirmation
set confirm

" disable .viminfo file
set viminfo="NONE"

" enable line number
set number

" show extra info on commands
set showcmd

" better cmd completion
set wildmenu

" enable hidden buffers
set hidden

" prevent many 'press <Enter> to continue'
set cmdheight=2


" Indentation setting
" tab character is displayed as 3 spaces
set tabstop=3
set shiftwidth=3
" Softtabstop: make x spaces feel like tabs
" If you use it, set it equal to tabstop and shiftwidth

" don't expand tabs into spaces
set expandtab

" auto indentation
set autoindent
set smartindent

filetype plugin indent on

" Syntastic settings
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_always_populate_loc_list = 1

" Key remappings
" map jj to esc
" inoremap jj <Esc>
" Remove this, since Caps is the new Esc

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

" REPL shortcut
nnoremap <C-c><C-c> :SlimuxREPLSendBuffer<CR>

" REPL configure shortcut
nnoremap <C-c><C-v> :SlimuxREPLConfigure<CR>

" ToggleHex command
nnoremap <C-h> :Hexmode<CR>

" Map Q to q
command! Q q

" Command :Hexmode to :call ToggleHex()
command! Hexmode call ToggleHex()

" Save as root
let s:save_as_root=0
command! W
   \ let s:save_as_root=1 |
   \ w !sudo tee %

autocmd! FileChangedShell *
   \ if s:save_as_root == 1 |
   \    let v:fcs_choice="reload" |
   \ endif

autocmd! FileChangedShellPost *
   \ if s:save_as_root == 1 |
   \   let v:fcs_choice="ask" |
   \   let s:save_as_root=0 |
   \ endif

" NEVER use undo after toggling hexmode. The old settings will not be restored!
function ToggleHex()
   " Save these flags, since we restore them after the conversion
   let l:modified=&mod
   let l:oldreadonly=&readonly
   let l:oldmodifiable=&modifiable
   let &readonly=0
   let &modifiable=1
   if !exists("b:editHex") || !b:editHex
      let b:editHex=1
      let b:oldft=&ft
      let b:oldbin=&bin

      setlocal binary

      let &ft="xxd"

      %!xxd -ps | sed 's/\(....\)/\1 /g'
   else
      let b:editHex=0
      let &ft=b:oldft

      if !b:oldbin
         setlocal nobinary
      endif

      %!xxd -r -ps
   endif

   " restore the flags
   let &mod=l:modified
   let &readonly=l:oldreadonly
   let &modifiable=l:oldmodifiable
endfunction
