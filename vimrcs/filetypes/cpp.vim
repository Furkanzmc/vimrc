setlocal foldmethod=indent

" Override the default comment string from vim-commentary
setlocal commentstring=//%s

function! SwapSourceHeader()
    let l:extension=expand('%:p:e')

    if l:extension == 'cpp'
        execute 'edit `fd %:t:r.h %:p:h`'
    elseif l:extension =='h'
        execute 'edit `fd %:t:r.cpp %:p:h`'
    endif
endfunction

nnoremap <leader>gg :call SwapSourceHeader()<CR>
nmap <leader>dh :call SearchDocs()<CR>

setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
