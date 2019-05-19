set background=dark
colorscheme cosmic_latte

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*

command! Golo Goyo85x70%
command! TogTheme call ToggleTheme()

function! ToggleTheme()
    if &background == "light"
        set background=dark
    else
        set background=light
    endif
endfunction
