"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" => Load pathogen paths
""""""""""""""""""""""""""""""
" Needs to be called before the plugin is enabled.
let g:ale_completion_enabled = 0

let s:vim_runtime = expand('<sfile>:p:h')."/.."
call pathogen#infect(s:vim_runtime.'/builtin_plugins/{}')
call pathogen#infect(s:vim_runtime.'/python_plugins/{}')
call pathogen#infect(s:vim_runtime.'/my_plugins/{}')
call pathogen#helptags()

let ofuc_path = s:vim_runtime.'/builtin_plugins/open_file_under_cursor.vim'
exec 'source ' . ofuc_path

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ale - Code Linting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

" Set this in your vimrc file to disabling highlighting
let g:ale_set_highlights = 0

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" We don't need live linting.
let g:ale_lint_on_text_changed = 'never'

let g:ale_lint_on_enter = 1

let g:ale_linters = {
\   'qml': ['qmllint'],
\   'python': ['pylint'],
\   'c++': ['clangtidy']
\}

let g:ale_linters_explicit = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1


""""""""""""""""""""""""""""""
" => vim-airline
""""""""""""""""""""""""""""""
" Hide the default show mode
set noshowmode


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden = 0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize = 35

map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>
map <leader>nc :NERDTreeCWD<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:multi_cursor_use_default_mapping = 0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-s>'
let g:multi_cursor_select_all_word_key = '<A-s>'
let g:multi_cursor_start_key           = 'g<C-s>'
let g:multi_cursor_select_all_key      = 'g<A-s>'
let g:multi_cursor_next_key            = '<C-s>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>

"""""""""""""""""""""""""""""""
" => vim-cpp-enhanced-highlight
"""""""""""""""""""""""""""""""

let g:cpp_member_variable_highlight = 1


""""""""""""""""""""""""""""""
" => fzf plugin
""""""""""""""""""""""""""""""

map <c-p> :Files<cr>
map <leader>o :Buffers<cr>
map <leader>s :Rg<cr>
map <leader>f :History<CR>
imap <c-x><c-f> <plug>(fzf-complete-path)

