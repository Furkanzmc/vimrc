setlocal foldmethod=indent

" Override the default comment string from vim-commentary
setlocal commentstring=//%s

if get(g:, "swap_source_loaded", 0) == 0
    let g:swap_source_loaded = 1
    function! SwapSourceHeader()
        let l:extension = expand('%:p:e')

        setlocal path+=expand('%:h')
        if l:extension == 'cpp'
            let l:filename = expand('%:t:r') . '.h'
        elseif l:extension =='h'
            let l:filename = expand('%:t:r') . '.cpp'
        endif

        try
            execute 'find ' . l:filename
        catch
            echo "Cannot file " . l:filename
        endtry

        setlocal path-=expand('%:h')
    endfunction
endif

nnoremap <buffer> <leader>gg :call SwapSourceHeader()<CR>
nmap <buffer> <leader>dh :call SearchDocs()<CR>

setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
