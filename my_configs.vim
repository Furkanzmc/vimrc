colorscheme onedark
" Map CtrlP shortcut
let g:ctrlp_map = '<c-p>'
set nu

" Autoclose YCM completion window
let g:ycm_autoclose_preview_window_after_completion=1
" Add shortcut for go to decleration
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*

" Access system clipboard on macOS.
set clipboard=unnamed
" Hide the default show mode because I'm using lightline
set noshowmode
set gfn=Fira\ Code\ Retina:h12

cmap GGT GitGutterToggle
cmap GGHL GitGutterLineHighlightsToggle

" ALE settings
" Disabling highlighting
let g:ale_set_highlights = 1

" Only run linting when saving the file
let g:ale_lint_on_enter = 1

" Use these to delete a line without cutting it.
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP
xnoremap <leader>c "_c

command Lcdc lcd %:p:h
command Cdc cd %:p:h

