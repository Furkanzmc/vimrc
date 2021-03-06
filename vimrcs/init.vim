" General {{{
" which commands trigger auto-unfold
set foldopen=block,hor,jump,mark,percent,quickfix,search,tag
set complete-=i
set noshowmode

set termguicolors
set nofoldenable
set colorcolumn=81

set completeopt-=preview
set splitbelow
set splitright

set signcolumn=yes

" Reduces the number of lines that are above the curser when I do zt.
set scrolloff=3

" Sets how many lines of history VIM has to remember
set history=500

" Show an arrow with a space for line breaks.
set showbreak=↳\ 

" Enable filetype plugins
filetype plugin on
filetype indent on

" Access system clipboard on macOS.
set clipboard=unnamed

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ' '
let maplocalleader = ' '

" Enable project specific settings
set exrc

" Use ripgrep over grep, if possible
if executable("rg")
   " Use rg over grep
   set grepprg=rg\ --vimgrep\ $*
   set grepformat=%f:%l:%c:%m
endif

try
    " Means that you can undo even when you close a buffer/VIM
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
" }}}

" User Interface {{{

if $VIMRC_BACKGROUND == "dark"
    set background=dark
elseif $VIMRC_BACKGROUND == "light"
    set background=light
else
    set background=dark
endif

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

set diffopt=vertical,filler
if has("nvim")
    set diffopt+=internal
endif

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en

set nu
set relativenumber

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.qmlc,*jsc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
   set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=3

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=300

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L


" Colors and Fonts {{{

" Enable syntax highlighting
syntax enable

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" }}}

" }}}

" Visual Mode {{{

" Visual mode pressing ~~*~~ or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" }}}

" Moving around, tabs, windows and buffers {{{

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Specify the behavior when switching between buffers
try
  " Use the current tab for openning files from quickfix.
  " Otherwise it gets really annoying and each file is opened
  " in a different tab.
  set switchbuf=useopen,usetab
  set stal=2
catch
endtry

" Use these to delete a line without cutting it.
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap p "_dP
xnoremap <leader>c "_c

" Mappings to [l]cd into the current file's directory.
command! Lcdc lcd %:p:h
command! Cdc cd %:p:h

" Return to last edit position when opening files (You want this!)
au BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$")
            \ | exe "normal! g'\"" | endif

" }}}

" Status line {{{
" Initial config from: https://jip.dev/posts/a-simpler-vim-statusline/

" Always show the status line
set laststatus=2

" This function just outputs the content colored by the
" supplied colorgroup number, e.g. num = 2 -> User2
" it only colors the input if the window is the currently
" focused one
function! ConfigureStatusline(winnum)
    function! Color(active, activeColor, inactiveColor)
        if a:active
            return '%#' . a:activeColor . '#'
        else
            return '%#' . a:inactiveColor . '#'
        endif
    endfunction

    let active = a:winnum == winnr()
    let g:currentmode={
                \ 'n'      : 'Normal',
                \ 'no'     : 'N.Operator Pending ',
                \ 'v'      : 'V',
                \ 'V'      : 'V.Line',
                \ '\<C-V>' : 'V.Block',
                \ 's'      : 'Select',
                \ 'S'      : 'S.Line',
                \ '\<C-S>' : 'S.Block',
                \ 'i'      : 'Insert',
                \ 'R'      : 'Replace',
                \ 'Rv'     : 'V.Replace',
                \ 'c'      : 'Command',
                \ 'cv'     : 'Vim Ex',
                \ 'ce'     : 'Ex',
                \ 'r'      : 'Prompt',
                \ 'rm'     : 'More',
                \ 'r?'     : 'Confirm',
                \ '!'      : 'Shell',
                \ 't'      : 'Terminal'
    \}

    let stat = ""

    " Mode sign {{{
    let excludedFileTypes = ["help", "qf", "terminal"]
    let stat .= Color(active, 'Visual', 'Comment')
    if active && &filetype == "fugitive"
        let stat .= " GIT "
    elseif active && &filetype == "terminal"
        let stat .= " Terminal "
    elseif active && index(excludedFileTypes, &filetype) == -1
        let stat .= " %{toupper(g:currentmode[mode()])} "
    endif
    " }}}

    let stat .= Color(active, 'Error', 'ErrorMsg')
    let stat .= '%h' " Help sign
    let stat .= '%q' " Help sign
    let stat .= '%w' " Preview sign

    " File path {{{
    if &filetype != "fugitive"
        let stat .= Color(active, 'Normal', 'Comment')
        let stat .= " %{IsFugitiveBuffer(expand('%')) ? expand('%:t') : expand('%')}"
endif
    " }}}

    " Diff file signs {{{

    let stat .= Color(1, 'Type', 'Type')
    let bufferGitTag = " %{"
    let bufferGitTag .= "&diff && IsFugitiveBuffer(expand('%')) ? '[head]' : "
    let bufferGitTag .= "(&diff && !IsFugitiveBuffer(expand('%')) ? '[local]' : '')"
    let bufferGitTag .= "}"
    let stat .= bufferGitTag

    " }}}

    let stat .= Color(active, 'Identifier', 'Comment')
    let stat .= '%r' " Readonly sign
    if &spell
        let stat .= ' ☰'
    endif

    " Modified sign {{{

    let stat .= Color(active, 'SpecialChar', 'Comment')
    let stat .= "%{&modified ? ' +' : ''}" " Modified sign

    if (active)
        let modifiedBufferCount = GetModifiedBufferCount()
        if (modifiedBufferCount > 0)
            let stat .= ' [✎ ' . modifiedBufferCount . '] '
        endif
    endif

    " }}}

    let stat .= '%=' " Switch to right side

    " Branch name {{{
    let stat .= Color(active, 'Visual', 'Comment')
    if exists("*fugitive#head") && active
        let head = fugitive#head()
        if empty(head) && exists('*FugitiveDetect') && !exists('b:git_dir')
            call FugitiveDetect(expand("%"))
            let head = fugitive#head()
        endif

        if !empty(head)
            let stat .= ' ʯ ' . head . ' '
        endif
    endif
    " }}}

    return stat
endfunction

function! s:RefreshStatus()
    for nr in range(1, winnr('$'))
        call setwinvar(nr, '&statusline', '%!ConfigureStatusline(' . nr . ')')
    endfor
endfunction

augroup Status
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * call <SID>RefreshStatus()
augroup END

" }}}

" Mappings {{{

command! MarkScratch :call MarkScratchBuffer()

nnoremap <leader>qn :next<CR>
nnoremap <leader>qp :previous<CR>
nnoremap <leader>ln :lnext<CR>
nnoremap <leader>lp :lprevious<CR>

" Remap VIM 0 to first non-blank character
map 0 ^

" Reselect text that was just pasted with ,v
nnoremap <leader>v V`]

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

map <leader>cn :cn<cr>
map <leader>cp :cp<cr>

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
cnoremap $q <C-\>eDeleteTillSlash()<cr>

" Sort the selected lines according to their lengths.
command! -range SortLength :call setline("'<", sort(getline("'<", "'>"), "CompareLength"))

vmap <leader>s :call VisualSelection('search', '')<CR>

nmap <leader>qt :call ToggleQuickFix()<CR>
nmap <leader>cc :call ToggleColorColumn(col('.'))<CR>
nmap <leader>cax :call ToggleColorColumn(-1)<CR>

" }}}

" Autocmd {{{

autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()

" Code from https://www.vim.org/scripts/script.php?script_id=443
if !exists("g:vimrc_loaded_spacehi")
    let g:vimrc_loaded_spacehi = v:true

    if !exists("g:spacehi_tabcolor")
        let g:spacehi_tabcolor = "ctermfg=137 cterm=undercurl"
        let g:spacehi_tabcolor = g:spacehi_tabcolor . " guifg=#b28761 gui=undercurl"
    endif

    if !exists("g:spacehi_spacecolor")
        let g:spacehi_spacecolor = "ctermbg=196"
        let g:spacehi_spacecolor = g:spacehi_spacecolor . " guibg='#EB5A2D'"
    endif

    function! s:SpaceHi()
        let bufferFileType = &filetype
        if bufferFileType == "help"
            return
        endif

        syntax match spacehiTab /\t/ containedin=ALL
        execute("highlight spacehiTab " . g:spacehi_tabcolor)

        syntax match spacehiTrailingSpace /\s\+$/ containedin=ALL
        execute("highlight spacehiTrailingSpace " . g:spacehi_spacecolor)
    endfunction

    autocmd BufWinEnter * call s:SpaceHi()
    autocmd InsertLeave * call s:SpaceHi()
    autocmd BufWinLeave * call s:SpaceHi()
endif

" }}}

" Misc {{{

command! Date :echo strftime("%b %d %a %I:%M %p")

" Don't close window, when deleting a buffer
command! Bclose :call BufcloseCloseIt()

command! -nargs=1 Bdeletes :call WipeMatchingBuffers('<args>')
command! Bdhidden :call DeleteHiddenBuffers()

command! -nargs=1 Search :call SearchDocs(<f-args>)

command! -nargs=? StartReview :call StartReview(<f-args>)
command! ReviewDiff :call ReviewDiff()

command! ClearQuickFix :call setqflist([])

function! s:CreateCustomNvimListenServer()
    if has('win32')
        return
    endif

    let pid = string(getpid())
    let socket_name = expand('~/.vim_runtime/temp_dirs/servers/nvim') . pid . '.sock'
    call serverstart(socket_name)
endfunction

augroup StartUp
    autocmd!
    autocmd VimEnter * call s:CreateCustomNvimListenServer()
augroup END

" }}}
