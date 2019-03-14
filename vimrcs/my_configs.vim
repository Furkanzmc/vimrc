if strftime('%H') >= 7 && strftime('%H') < 15
  set background=light
  let g:airline_theme='cosmic_latte_light'
else
  set background=dark
  let g:airline_theme='cosmic_latte_dark'
endif
colorscheme cosmic_latte

set termguicolors
set nofoldenable
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*

" Keyboard Mappings
" Use these to delete a line without cutting it.
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP
xnoremap <leader>c "_c

command! Lcdc lcd %:p:h
command! Cdc cd %:p:h
