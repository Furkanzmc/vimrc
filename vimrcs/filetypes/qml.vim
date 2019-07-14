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

setlocal foldmethod=indent
