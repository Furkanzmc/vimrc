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
let g:vim_runtime = expand('<sfile>:p:h')."/.."

function! PackInit()
    packadd minpac
    call minpac#init()

    call minpac#add('sheerun/vim-polyglot')
    call minpac#add('tpope/vim-commentary')
    call minpac#add('tpope/vim-fugitive')
    call minpac#add('tpope/vim-surround')
    call minpac#add('octol/vim-cpp-enhanced-highlight')
    call minpac#add('mkitt/tabline.vim')
    call minpac#add('w0rp/ale')
    call minpac#add('majutsushi/tagbar')
    call minpac#add('junegunn/fzf.vim')
    call minpac#add('junegunn/fzf')
    call minpac#add('freitass/todo.txt-vim')
    call minpac#add('nightsense/cosmic_latte')
    call minpac#add('Vimjas/vim-python-pep8-indent')
    call minpac#add('junegunn/goyo.vim')
    call minpac#add('masukomi/vim-markdown-folding')
    call minpac#add('vim-scripts/SyntaxRange')
    call minpac#add('skywind3000/asyncrun.vim')
    call minpac#add('SirVer/ultisnips')
    call minpac#add('tmsvg/pear-tree')
    call minpac#add('sakhnik/nvim-gdb')
    call minpac#add('justinmk/vim-dirvish')

    call minpac#add('autozimu/LanguageClient-neovim', {'branch': 'next'})
    call minpac#add('Shougo/deoplete.nvim', {'do': 'UpdateRemotePlugins'})
endfunction

if exists('*minpac#init')
    call PackInit()
endif

command! PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
    command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()

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

let availableCppLinter = ''
if executable('ccls')
    let availableCppLinter = 'ccls'
elseif executable('cquery')
    let availableCppLinter = 'cquery'
elseif executable('clangd')
    let availableCppLinter = 'clangd'
endif

let g:ale_linters = {
            \   'qml': ['qmllint'],
            \   'python': ['pylint'],
            \   'cpp': [availableCppLinter],
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

let g:deoplete#enable_at_startup = 0
augroup Doplete
    autocmd!
    autocmd FileType * call deoplete#enable()
    " Enable auto complete only when the menu is visible. Otherwise it's just
    " annoying.
    autocmd TextChangedP * call deoplete#custom#option('auto_complete', 1)
    autocmd CompleteDone * call deoplete#custom#option('auto_complete', 0)
augroup END

" Pass a dictionary to set multiple options
autocmd VimEnter * call deoplete#custom#option({
            \   'smart_case': v:false,
            \   'auto_complete': v:false,
            \   'max_list': 100
            \ })

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

let g:LanguageClient_serverCommands = {
            \ 'c': [availableCppLinter],
            \ 'cpp': [availableCppLinter],
            \ 'python': ['pyls'],
            \ }

function! SetLSPShortcuts()
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
endfunction()

let g:LanguageClient_diagnosticsList = "Location"
let g:LanguageClient_diagnosticsEnable = 0
augroup LSP
    autocmd!
    autocmd FileType cpp,c,python call SetLSPShortcuts()
augroup END

set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

let g:LanguageClient_selectionUI = "fzf"
let g:LanguageClient_completionPreferTextEdit = 0
let g:LanguageClient_useVirtualText = 0

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#manual_complete()
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => asyncrun.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
