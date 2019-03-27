set background=dark
let g:airline_theme='cosmic_latte_dark'
colorscheme cosmic_latte

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*

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

command! Golo Goyo85x70%
