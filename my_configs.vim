colorscheme gotham256
let g:lightline = { 'colorscheme': 'gotham256' }
" Map CtrlP shortcut
let g:ctrlp_map = '<c-p>'
set nu
set nocursorcolumn
set cursorline

" YCM
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

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*

" Access system clipboard on macOS.
set clipboard=unnamed
" Hide the default show mode because I'm using lightline
set noshowmode
set gfn=Hack\ Regular\ Retina:h12

cmap GGT GitGutterToggle
cmap GGHL GitGutterLineHighlightsToggle

" ALE settings
" Disabling highlighting
let g:ale_set_highlights = 1

" Only run linting when saving the file
let g:ale_lint_on_enter = 1

" Keyboard Mappings
"
" Use these to delete a line without cutting it.
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP
xnoremap <leader>c "_c

command Lcdc lcd %:p:h
command Cdc cd %:p:h

" NERDtree
map <leader>nc :NERDTreeFind<cr>

let g:ale_linters_explicit = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Tabbar Settings
g:tagbar_show_linenumbers = 1

" vim-clang-format Settings
g:clang_format#detect_style_file = 1

