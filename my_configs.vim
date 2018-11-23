colorscheme gotham256
let g:lightline = { 'colorscheme': 'gotham256' }

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*

set gfn=Hack\ Regular\ Retina:h12

" Keyboard Mappings
" Use these to delete a line without cutting it.
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP
xnoremap <leader>c "_c

command Lcdc lcd %:p:h
command Cdc cd %:p:h

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Settings for my_plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tabbar Settings
g:tagbar_show_linenumbers = 1

" vim-clang-format Settings
g:clang_format#detect_style_file = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YouCompleteMe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Autoclose completion window
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_global_ycm_extra_conf='~/.vim_runtime/ycm_extra_conf.py'
map <leader>k :YcmCompleter GetDoc<cr>

" Add shortcut for go to decleration
map <leader>gd  :YcmCompleter GoToDeclaration<CR>
map <leader>gt  :YcmCompleter GoTo<CR>
map <leader>gr  :YcmCompleter GoToReferences<CR>
command YD YcmDiags
