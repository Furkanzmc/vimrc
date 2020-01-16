inoremap <c-s> <esc>Ion<esc>l~A: {<CR>}<ESC>O
inoremap <c-d> <esc>Ion<esc>l~AChanged: {<CR>}<ESC>O

function! RunSelectedQMLCode()
    if executable('qmlscene')
        let lines = GetVisualSelection()
        let tempfile = tempname() . '.qml'
        call insert(lines, "import QtQuick 2.10")
        call insert(lines, "import QtQuick.Controls 2.3")
        call insert(lines, "import QtQuick.Layouts 1.3")
        call insert(lines, "import QtQuick.Window 2.3")
        call writefile(lines, tempfile)
        execute 'AsyncRun qmlscene ' . shellescape(tempfile)
    else
        echohl WarningMsg
        echo "Cannot find qmlscene in the path."
        echohl None
    endif
endfunction

function! RunQMLScene()
    if executable('qmlscene')
        execute 'AsyncRun qmlscene %'
    else
        echohl WarningMsg
        echo "Cannot find qmlscene in the path."
        echohl None
    endif
endfunction

command! RunQML :call RunQMLScene()
command! -range RunQMLSelected :call RunSelectedQMLCode()

setlocal foldmethod=indent
nmap <leader>dh :call SearchDocs()<CR>

