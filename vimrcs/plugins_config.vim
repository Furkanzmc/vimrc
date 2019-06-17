"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => Load Plugins
""""""""""""""""""""""""""""""
" Needs to be called before the plugin is enabled.
let g:ale_completion_enabled = 0

" Disable netrw in favor of vim-dirvish
let loaded_netrwPlugin = 1

" Disable markdown support for polyglot because it messes up with syntax
" highlighting.
let g:polyglot_disabled = ['markdown']

set rtp+=~/.vim/bundle/Vundle.vim

set nocompatible
filetype off

call vundle#begin()

Plugin 'sheerun/vim-polyglot'
Plugin 'peterhoeg/vim-qml'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'pboettch/vim-cmake-syntax'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'mkitt/tabline.vim'
Plugin 'w0rp/ale'
Plugin 'majutsushi/tagbar'
Plugin 'artoj/qmake-syntax-vim'
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/fzf'
Plugin 'freitass/todo.txt-vim'
Plugin 'nightsense/cosmic_latte'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'junegunn/goyo.vim'
Plugin 'neoclide/coc.nvim'
Plugin 'masukomi/vim-markdown-folding'
Plugin 'vim-scripts/SyntaxRange'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'SirVer/ultisnips'
Plugin 'tmsvg/pear-tree'
Plugin 'sakhnik/nvim-gdb'
Plugin 'justinmk/vim-dirvish'

call vundle#end()

filetype plugin indent on

let g:vim_runtime = expand('<sfile>:p:h')."/.."

colorscheme cosmic_latte

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ale - Code Linting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

" Set this in your vimrc file to disabling highlighting
let g:ale_set_highlights = 0

" We don't need live linting.
let g:ale_lint_on_text_changed = 'never'

" Use the virtual text to show errors. Coc.nvim redirects the errors to
" ale, so this is useful.
let g:ale_virtualtext_cursor = 0

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

"""""""""""""""""""""""""""""""
" => vim-cpp-enhanced-highlight
"""""""""""""""""""""""""""""""

let g:cpp_member_variable_highlight = 1


""""""""""""""""""""""""""""""
" => fzf plugin
""""""""""""""""""""""""""""""

map <c-p> :Files<cr>
map <leader>o :Buffers<cr>
nmap <leader>s :Rg<cr>
map <leader>f :History<CR>
imap <c-x><c-f> <plug>(fzf-complete-path)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => TagBar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:tagbar_show_linenumbers = 1

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
            \   "suggest.autoTrigger": "none",
            \   "python.linting.pylintArgs": ["--load-plugins pylint_django"]
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UltiSnips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"

let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsSnippetDirectories = [g:vim_runtime.'/default_snippets']
