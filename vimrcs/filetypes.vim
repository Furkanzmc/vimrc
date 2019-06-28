""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <c-t> $log();<esc>hi
au FileType javascript imap <c-a> alert();<esc>hi

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction

""""""""""""""""""""""""""""""
" => Shell section
""""""""""""""""""""""""""""""
if exists('$TMUX')
    if has('nvim')
        set termguicolors
    else
        set term=screen-256color
    endif
endif

""""""""""""""""""""""""""""""
" => Markdown section
""""""""""""""""""""""""""""""
function! RegisterSyntaxGroups()
    call SyntaxRange#Include('```qml', '```', 'qml', 'NonText')
    call SyntaxRange#Include('```css', '```', 'css', 'NonText')
    call SyntaxRange#Include('```html', '```', 'html', 'NonText')
    call SyntaxRange#Include('```cpp', '```', 'cpp', 'NonText')
    call SyntaxRange#Include('```json', '```', 'json', 'NonText')
endfunction

au FileType markdown call RegisterSyntaxGroups()


""""""""""""""""""""""""""""""
" => QML section
""""""""""""""""""""""""""""""
augroup qml_mappings
  autocmd!
  " Add shorts transform to a signal handler.
  autocmd FileType qml inoremap <c-d> <esc>Ion<esc>l~AChanged: {<CR>}<ESC>O
  autocmd FileType qml inoremap <c-s> <esc>Ion<esc>l~A: {<CR>}<ESC>O
augroup end

if executable('qmlscene')
    command! RunQML :execute 'AsyncRun qmlscene %'
    command! -range RunQMLSelected :call RunSelectedQMLCode()

    function! RunSelectedQMLCode()
        let lines = GetVisualSelection()
        let tempfile = tempname() . '.qml'
        call insert(lines, "import QtQuick 2.10")
        call writefile(lines, tempfile)
        execute 'AsyncRun qmlscene ' . shellescape(tempfile)
    endfunction
endif
