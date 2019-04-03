set background=dark
let g:airline_theme='cosmic_latte_dark'
colorscheme cosmic_latte

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*

command! Golo Goyo85x70%
command! TogTheme call ToggleTheme()

function! ToggleTheme()
    if &background == "light"
        set background=dark
        execute "AirlineTheme cosmic_latte_dark"
    else
        set background=light
        execute "AirlineTheme cosmic_latte_light"
    endif
endfunction
