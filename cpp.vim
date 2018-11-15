" TODO: Check if the files exist.
au BufRead,BufNewFile *.cpp nnoremap <leader>gh :e `find %:h:r -name %:r.h`<CR>
au BufRead,BufNewFile *.h noremap <leader>gs :e `find %:h:r -name %:r.cpp`<CR>

set foldmethod=indent

