let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_color_gui = '#29363f'

set background=dark
let g:airline_theme='cosmic_latte_dark'
colorscheme cosmic_latte

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.qmlc,*.jsc,*/libs/*

command! Golo Goyo85x70%
command! TogTheme call ToggleTheme()

function! ToggleTheme()
    if &background == "light"
        let g:indentLine_color_gui = '#29363f'
        set background=dark
        execute "AirlineTheme cosmic_latte_dark"
    else
        let g:indentLine_color_gui = '#f0e9d9'
        set background=light
        execute "AirlineTheme cosmic_latte_light"
    endif
endfunction
