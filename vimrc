" Display options
set encoding=utf-8
set number
syntax on

" Tabs and spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Key Mapping
inoremap jk <esc> 

" Copy and paste
" vim +clipboard required
vmap <C-c> "+yi
vmap <C-v> c<esc>"+p
imap <C-v> <C-r><C-o>+

" Search
set ignorecase
