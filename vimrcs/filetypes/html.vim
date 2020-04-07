setlocal colorcolumn=120

autocmd BufRead *.html call SetIndentSize(2)
autocmd BufNew *.html call SetIndentSize(2)
