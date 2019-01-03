colorscheme one
set background=dark
set termguicolors
let g:airline_theme='one'

set nofoldenable
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*
set gfn=Hack\ Regular\ Retina:h12

" Keyboard Mappings
" Use these to delete a line without cutting it.
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP
xnoremap <leader>c "_c

command! Lcdc lcd %:p:h
command! Cdc cd %:p:h

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Settings for my_plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tabbar Settings
let g:tagbar_show_linenumbers = 1

" vim-clang-format Settings
let g:clang_format#detect_style_file = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YouCompleteMe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Autoclose completion window
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_global_ycm_extra_conf = '~/.vim_runtime/ycm_extra_conf.py'

let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_auto_trigger = 0
map <leader>k :YcmCompleter GetDoc<cr>

" Add shortcut for go to decleration
map <leader>gd  :YcmCompleter GoToDeclaration<CR>
map <leader>gt  :YcmCompleter GoTo<CR>
map <leader>gr  :YcmCompleter GoToReferences<CR>
map <leader>ti  :YcmCompleter GetType<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => TagBar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <leader>tb  :Tagbar<CR>
map <leader>tbs  :TagbarShowTag<CR>
