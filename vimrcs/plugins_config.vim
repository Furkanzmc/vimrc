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
Plugin 'masukomi/vim-markdown-folding'
Plugin 'vim-scripts/SyntaxRange'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'SirVer/ultisnips'
Plugin 'tmsvg/pear-tree'
Plugin 'sakhnik/nvim-gdb'
Plugin 'justinmk/vim-dirvish'

Plugin 'autozimu/LanguageClient-neovim'
Plugin 'Shougo/deoplete.nvim'

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

" Use the virtual text to show errors. Coc.nvim redirects the errors to
" ale, so this is useful. But distracting so I only enable it for live coding.
let g:ale_virtualtext_cursor = 0
let g:ale_virtualtext_prefix = "-> "

let g:ale_linters = {
\   'qml': ['qmllint'],
\}

let g:ale_linters_explicit = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_lint_delay = 1000
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '--'

" We don't need live linting.
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

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
" => Completion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:deoplete#enable_at_startup = 1
" Pass a dictionary to set multiple options
call deoplete#custom#option({
\   'auto_complete_delay': 100,
\   'smart_case': v:false,
\   'auto_complete': v:false,
\   'max_list': 100
\ })

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

if len($CCLS_PATH) == 0
    echo "CCLS_PATH is not expored."
endif

if len($PYLS_PATH) == 0
    echo "PYLS_PATH is not expored."
endif

let g:LanguageClient_serverCommands = {
    \ 'cpp': [$CCLS_PATH],
    \ 'python': [$PYLS_PATH],
    \ }

function SetLSPShortcuts()
    nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
    nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
    command! Format :call LanguageClient#textDocument_formatting()<CR>

    nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
    nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>

    nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>

    nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
    nnoremap <leader>lh :call LanguageClient_textDocument_documentHighlight()<CR>
    nnoremap <leader>lc :call LanguageClient#clearDocumentHighlight()<CR>
    nnoremap <leader>le :call LanguageClient#explainErrorAtPoint()<CR>
endfunction()

let g:LanguageClient_diagnosticsList = "Location"
augroup LSP
  autocmd!
  autocmd FileType cpp,c,python call SetLSPShortcuts()
augroup ENk

set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

let g:LanguageClient_selectionUI = "fzf"
let g:LanguageClient_useVirtualText = 0

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? deoplete#refresh() :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UltiSnips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"

let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsSnippetDirectories = [g:vim_runtime . '/default_snippets']
