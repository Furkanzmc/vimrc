set background=dark
let g:airline_theme='cosmic_latte_dark'
colorscheme cosmic_latte

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*

command! Lcdc lcd %:p:h
command! Cdc cd %:p:h

if executable('qmlscene')
    command! RunQML AsyncRun qmlscene %
    command! -range RunSelectedQML :call RunSelectedQMLCode()

    function! RunSelectedQMLCode()
        let tempfile = tempname() . '.qml'
        let lines = GetVisualSelection()
        call insert(lines, "import QtQuick 2.10")
        call writefile(lines, tempfile)
        execute 'AsyncRun qmlscene ' . shellescape(tempfile)
    endfunction
endif
