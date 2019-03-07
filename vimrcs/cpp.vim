" TODO: Check if the files exist.

if executable('fd')
    au BufRead,BufNewFile *.cpp nnoremap <leader>gh :e `fd %:t:r.h %:p:h`<CR>
    au BufRead,BufNewFile *.h noremap <leader>gs :e `fd %:t:r.cpp %:p:h`<CR>
else
    au BufRead,BufNewFile *.cpp nnoremap <leader>gh :e `find %:p:h -name %:t:r.h`<CR>
    au BufRead,BufNewFile *.h noremap <leader>gs :e `find %:p:h -name %:t:r.cpp`<CR>
endif

set foldmethod=indent

" Override the default comment string from vim-commentary
setlocal commentstring=//%s
