setlocal commentstring=//\ %s
setlocal colorcolumn=120

autocmd BufRead *.vue call SetIndentSize(2)
autocmd BufNew *.vue call SetIndentSize(2)
