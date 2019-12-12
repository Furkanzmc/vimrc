" Python indentation
let python_highlight_all = 1
syn keyword pythonDecorator True None False self

setlocal cindent
setlocal cinkeys-=0#
setlocal indentkeys-=0#

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=100
setlocal expandtab
setlocal autoindent
setlocal foldmethod=indent
setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

nmap <leader>dh :call SearchDocs()<CR>

set wildignore+=*.pyc,__pycache__

if executable("black")
    autocmd BufRead *.py command! Black :!black --line-length=80 %
endif
