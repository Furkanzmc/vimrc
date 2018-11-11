" Python indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=100
set expandtab
set autoindent
set foldmethod=indent

" vim-flake8 Settings
" Auto run the flake8 when the file is saved
autocmd BufWritePost *.py call Flake8()

let g:flake8_show_in_gutter=1

