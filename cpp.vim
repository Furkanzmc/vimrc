" TODO: Check if the files exist.
au BufRead,BufNewFile *.cpp nnoremap <leader>gh :e `find %:p:h -name %:t:r.h`<CR>
au BufRead,BufNewFile *.h noremap <leader>gs :e `find %:p:h -name %:t:r.cpp`<CR>

set foldmethod=indent

