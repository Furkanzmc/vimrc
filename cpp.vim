" TODO: Check if the files exist.
au BufRead,BufNewFile *.cpp nnoremap <leader>gh :e `find ./ -name %:t:r.h`<CR>
au BufRead,BufNewFile *.h noremap <leader>gs :e `find ./ -name %:t:r.cpp`<CR>

set foldmethod=indent

