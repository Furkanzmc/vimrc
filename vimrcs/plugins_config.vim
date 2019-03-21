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
let g:pathogen_disabled = []
" Disable markdown support for polyglot because it messes up with syntax
" highlighting.
let g:polyglot_disabled = ['markdown']

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

" Use the virtual text to show errors. Coc.nvim redirects the errors to
" ale, so this is useful.
let g:ale_virtualtext_cursor = 1

let g:ale_linters = {
\   'qml': ['qmllint'],
\   'python': ['pylint'],
\   'c++': ['clang-tidy']
\}

let g:ale_linters_explicit = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_lint_delay = 500
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '--'
let g:ale_lint_on_enter = 1

let g:ale_virtualtext_prefix = "-> "

nmap <leader>ge  <Plug>(ale_detail)

""""""""""""""""""""""""""""""
" => vim-airline
""""""""""""""""""""""""""""""
" Hide the default show mode
set noshowmode

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


""""""""""""""""""""""""""""""
" => Tabbar plugin
""""""""""""""""""""""""""""""
let g:tagbar_show_linenumbers = 1


""""""""""""""""""""""""""""""
" => vim-clang-format plugin
""""""""""""""""""""""""""""""
let g:clang_format#detect_style_file = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => TagBar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <leader>tb  :Tagbar<CR>
map <leader>tbs  :TagbarShowTag<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => asyncrun
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => coc.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call coc#config("coc.preferences", {
            \   "timeout": 1000,
            \   "diagnostic.displayByAle": 1,
            \   "diagnostic.enableMessage": "never",
            \   "suggest.autoTrigger": "none"
            \ }
            \)
if executable('clangd')
    call coc#config("languageserver", {
                \   "clangd": {
                \       "command": "clangd",
                \       "rootPatterns": [
                \           "compile_flags.txt",
                \           "compile_commands.json",
                \           ".nvimrc",
                \           ".git/",
                \           ".hg/"
                \       ],
                \       "filetypes": [
                \           "c",
                \           "cpp",
                \           "objc",
                \           "objcpp"
                \       ]
                \   }
                \})
elseif executable('ccls')
    call coc#config("languageserver", {
                \   "ccls": {
                \       "command": "ccls",
                \       "filetypes": ["c", "cpp", "objc", "objcpp"],
                \       "rootPatterns": [".ccls", "compile_commands.json", ".vim/", ".git/", ".hg/"],
                \       "initializationOptions": {
                \           "cache": {
                \               "directory": "/tmp/ccls"
                \           }
                \       }
                \   }
                \})
else
    echo "Both ccls and clangd do not exist."
endif

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Took from here: https://coderwall.com/p/cl6cpq/vim-ctrl-space-omni-keyword-completion
" Required to make Ctr+Space work on VimR.
imap <C-@> <C-Space>

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }
