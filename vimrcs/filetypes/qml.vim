inoremap <c-s> <esc>Ion<esc>l~A: {<CR>}<ESC>O
inoremap <c-d> <esc>Ion<esc>l~AChanged: {<CR>}<ESC>O

if executable('qmlscene')
    command! RunQML :execute 'AsyncRun qmlscene %'
    command! -range RunQMLSelected :call RunSelectedQMLCode()

    function! RunSelectedQMLCode()
        let lines = GetVisualSelection()
        let tempfile = tempname() . '.qml'
        call insert(lines, "import QtQuick 2.10")
        call insert(lines, "import QtQuick.Controls 2.3")
        call insert(lines, "import QtQuick.Layouts 1.3")
        call insert(lines, "import QtQuick.Window 2.3")
        call writefile(lines, tempfile)
        execute 'AsyncRun qmlscene ' . shellescape(tempfile)
    endfunction
endif

setlocal foldmethod=indent
nmap <leader>dh :call SearchDocs()<CR>
