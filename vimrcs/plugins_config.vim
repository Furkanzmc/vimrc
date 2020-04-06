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

let g:vim_runtime = expand('<sfile>:p:h')."/.."
let g:vimrc_rust_enabled = empty($VIMRC_RUST_ENABLED)
if !empty($VIMRC_USE_VIRTUAL_TEXT)
    let g:vimrc_use_virtual_text = $VIMRC_USE_VIRTUAL_TEXT
else
    let g:vimrc_use_virtual_text = "No"
endif

function! PackInit()
    packadd minpac
    call minpac#init()

    call minpac#add('sheerun/vim-polyglot')
    call minpac#add('tpope/vim-commentary')
    call minpac#add('tpope/vim-fugitive')

    call minpac#add('machakann/vim-sandwich')
    call minpac#add('octol/vim-cpp-enhanced-highlight')
    call minpac#add('w0rp/ale')

    call minpac#add('majutsushi/tagbar')
    call minpac#add('junegunn/fzf.vim')
    call minpac#add('junegunn/fzf')

    call minpac#add('nightsense/cosmic_latte')
    call minpac#add('Vimjas/vim-python-pep8-indent')

    call minpac#add('junegunn/goyo.vim')
    call minpac#add('masukomi/vim-markdown-folding')
    call minpac#add('vim-scripts/SyntaxRange')

    call minpac#add('skywind3000/asyncrun.vim')
    call minpac#add('tmsvg/pear-tree')
    " This takes care of the tab line setting, so I no longer need tabline.vim.
    call minpac#add('gcmt/taboo.vim')

    call minpac#add('justinmk/vim-dirvish')
    call minpac#add('autozimu/LanguageClient-neovim', {'branch': 'next'})
    call minpac#add('Shougo/deoplete.nvim', {'do': 'UpdateRemotePlugins'})

    call minpac#add('mcchrish/info-window.nvim')

    if has('win32') == 0
        call minpac#add('sakhnik/nvim-gdb')
    endif

    if g:vimrc_rust_enabled
        call minpac#add('rust-lang/rust.vim')
    endif
endfunction

if exists('*minpac#init')
    call PackInit()
endif

command! PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()


autocmd VimEnter * colorscheme cosmic_latte


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ale - Code Linting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

" Use the virtual text to show errors. Distracting so I only enable it for live
" coding.
let g:ale_virtualtext_cursor = 0
let g:ale_virtualtext_prefix = "-> "

let g:ale_linters = {
            \   'qml': ['qmllint'],
            \}

if executable("mypy") && get(g:, "vimrc_disable_mypy", 0)
    let g:ale_linters["python"] = ["mypy"]
endif

let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_lint_delay = 1000
let g:ale_sign_error = "!!"
let g:ale_sign_info = "--"
let g:ale_sign_warning = "++"

" We don't need live linting.
let g:ale_lint_on_text_changed = 'never'

nmap <leader>ge  <Plug>(ale_detail)

"""""""""""""""""""""""""""""""
" => vim-cpp-enhanced-highlight
"""""""""""""""""""""""""""""""

let g:cpp_member_variable_highlight = 1


""""""""""""""""""""""""""""""
" => fzf plugin
""""""""""""""""""""""""""""""

map <leader>o :Files<cr>
map <leader>b :Buffers<cr>
nmap <leader>s :Rg<cr>
map <leader>h :History<CR>
imap <c-x><c-f> <plug>(fzf-complete-path)

let g:fzf_preview_window = ''
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = "--graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --color=always"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => TagBar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:tagbar_show_linenumbers = 1

map <leader>tb  :Tagbar<CR>
map <leader>tbs  :TagbarShowTag<CR>

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Completion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:deoplete#enable_at_startup = 1
augroup Doplete
    autocmd!
    " Enable auto complete only when the menu is visible. Otherwise it's just
    " annoying.
    autocmd TextChangedP * call deoplete#custom#option('auto_complete', v:true)
    autocmd CompleteDone * call deoplete#custom#option('auto_complete', v:false)
augroup END

" Pass a dictionary to set multiple options
autocmd VimEnter * call deoplete#custom#option({
            \   'smart_case': v:false,
            \   'auto_complete': v:false,
            \   'max_list': 100
            \ })

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other
" plugin.
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ CheckBackSpace() ? "\<TAB>" :
            \ deoplete#manual_complete()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><c-f> pumvisible() ? deoplete#manual_complete() : "\<C-f>"

let g:vimrc_cpp_servers = []
let g:vimrc_python_server = []
let g:vimrc_rust_server = []

if executable("ccls")
    call add(g:vimrc_cpp_servers, "ccls")
elseif executable("cquery")
    call add(g:vimrc_cpp_servers, "cquery")
elseif executable("clangd")
    call add(g:vimrc_cpp_servers, "clangd")
else
    echomsg "No C++ linter is found."
endif

if executable("pyls")
    call add(g:vimrc_python_server, "pyls")
else
    echomsg "No Python language server is found."
endif

if g:vimrc_rust_enabled
    if executable("rls")
        call add(g:vimrc_rust_server, "rls")
    elseif executable("rustup")
        let g:vimrc_rust_server = ["rustup", "run", "stable", "rls"]
    else
        echomsg "No Rust language server is found."
    endif
endif

let g:LanguageClient_serverCommands = {}
if len(g:vimrc_cpp_servers) > 0
    let g:LanguageClient_serverCommands["c"] = g:vimrc_cpp_servers
    let g:LanguageClient_serverCommands["cpp"] = g:vimrc_cpp_servers
endif

if len(g:vimrc_python_server) > 0
    let g:LanguageClient_serverCommands["python"] = g:vimrc_python_server
endif

if len(g:vimrc_rust_server) > 0
    let g:LanguageClient_serverCommands["rust"] = g:vimrc_rust_server
endif

command! Format :call LanguageClient#textDocument_formatting()<CR>
command! RFormat :call LanguageClient#textDocument_rangeFormatting()<CR>
nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>

nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
vnoremap <leader>f :call LanguageClient#textDocument_rangeFormatting()<CR>
nnoremap <leader>f :call LanguageClient#textDocument_formatting()<CR>

nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>

nnoremap <leader>lh :call LanguageClient_textDocument_documentHighlight()<CR>
nnoremap <leader>lc :call LanguageClient#clearDocumentHighlight()<CR>

let g:LanguageClient_diagnosticsList = "Location"
let g:LanguageClient_selectionUI = "fzf"
let g:LanguageClient_useVirtualText = g:vimrc_use_virtual_text

" let g:LanguageClient_virtualTextPrefix = '>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => asyncrun.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => nvim-gdb
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:nvimgdb_config_override = {
            \ "key_step": "<leader>s",
            \ "key_frameup": "<leader>u",
            \ "key_framedown": "<leader>d",
            \ "key_continue":   "<leader>c",
            \ "key_next":       "<leader>n",
            \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => information-window
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! plugins_config#show_file_info(default_lines)
    let currentTime = strftime('%b %d, %H:%M')
    let l:lines = [
        \ "",
        \ " [" . currentTime . "] ",
        \ " Line: " . line('.') . ":" . col('.'),
        \ ]

    if len(&filetype) > 0
        let fileTypeStr = " File: " . &filetype . ' - ' . &fileencoding .
                    \ ' [' . &fileformat . '] '

        call insert(l:lines, fileTypeStr, 2)
    endif

    let l:Custom_lines_func = get(g:, "Vimrc_info_window_lines_func", v:null)
    if l:Custom_lines_func != v:null
        let l:custom_lines = l:Custom_lines_func()
        if len(l:custom_lines) > 0
            call add(l:lines, " -----")
        endif

        for line in l:custom_lines
            call add(l:lines, line)
        endfor
    endif

    call add(l:lines, "")
    return l:lines
endfunction


nmap <silent> <leader>i :call infowindow#create(
            \ {}, function("plugins_config#show_file_info"))<CR>
