function! BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(mode, str)
    call feedkeys(a:mode . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'search'
        call CmdLine('/', l:pattern)
    elseif a:direction == 'replace'
        call CmdLine(':', "%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! SetIndentSize(size)
    let &l:tabstop = a:size
    let &l:softtabstop = a:size
    let &l:shiftwidth = a:size
endfunction

func! CompareLength(a, b)
    let x = strlen(a:a)
    let y = strlen(a:b)
    return (x == y) ? 0 : (x < y) ? -1 : 1
endfunc

func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

" Code taken from here: https://stackoverflow.com/a/6271254
function! GetVisualSelection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return lines
    endif

    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return lines
endfunction

" Buffer related code from https://stackoverflow.com/a/4867969
function! GetBufferList()
    return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunction

function! GetMatchingBuffers(pattern)
    return filter(GetBufferList(), 'bufname(v:val) =~ a:pattern')
endfunction

function! WipeMatchingBuffers(pattern)
    if a:pattern == "*"
        let l:matchList = GetBufferList()
    else
        let l:matchList = GetMatchingBuffers(a:pattern)
    endif

    let l:count = len(l:matchList)
    if l:count < 1
        echo 'No buffers found matching pattern ' . a:pattern
        return
    endif

    if l:count == 1
        let l:suffix = ''
    else
        let l:suffix = 's'
    endif

    exec 'bw ' . join(l:matchList, ' ')

    echo 'Wiped ' . l:count . ' buffer' . l:suffix . '.'
endfunction

" Delete all hidden buffers
" From https://github.com/zenbro/dotfiles/blob/master/.nvimrc
function! DeleteHiddenBuffers()
    let tpbl = []
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    let l:matchList = filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    let l:count = len(l:matchList)
    for buf in l:matchList
        silent execute 'bwipeout' buf
    endfor

    if l:count > 0
        echo 'Closed ' . l:count . ' hidden buffers.'
    else
        echo 'No hidden buffer present.'
    endif
endfunction

" Taking from here: https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
" Allows running macros only on selected files.
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

function! IsFugitiveBuffer(bufferName)
    if has('win32')
        return match(a:bufferName, 'fugitive:\\') != -1
    endif

    return match(a:bufferName, 'fugitive://') != -1
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Go to file functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Initial code belongs to Rudy Wortel

function! s:GrepOutput()
    "C:/Studio/main/Jamrules.jam:134: dummy text "this/is/a/file:123: parse this!
    let status = 0
    let matchList = matchlist(s:fileLine, '^\([a-zA-Z]\):\([^:]*\):\([0-9]*\):')
    if len(matchList)
        let s:cmd = "edit +" . matchList[3] . " " . matchList[1] . ":" . matchList[2]
        let status = 1
    else
        let matchList = matchlist( s:fileLine, '^\([^:]*\):\([0-9]*\):' )
        if len( matchList )
            let s:cmd = "edit +" . matchList[2] . " " . matchList[1]
            let status = 1
        endif
    endif

    return status
endfunction

function! s:MSCEError()
    "c:\main\build\Release\units\Foundation\include\MFn.h(90) : error C2061: syntax error : identifier 'kBase'
    let status = 0
    let matchList = matchlist(s:fileLine, '^ *\([^(]*\)(\([0-9]*\)) : \([^ ]*\)')
    if len(matchList)
        let type = matchList[3]
        if type ==? "error" || type ==? "warning" || type ==? "fatal" || type ==? "see" || type ==? "while"
            let s:cmd = "edit +" . matchList[2] . " " . matchList[1]
            let status = 1
        endif
    endif

    return status
endfunction

function! s:IncludeStatement()
    let status = 0
    let matchList = matchlist( s:fileLine, '^#[     ]*include[     ]*["<]\([^">]*\)' )

    if len(matchList)
        let s:cmd = "tag " . matchList[1]
        let status = 1
    endif

    return status
endfunction

function! s:IncludeFrom()
    let status = 0
    let matchList = matchlist(s:fileLine, '^In file included from \([^:>]*\):\([0-9]*\)')

    if len(matchList)
        let s:cmd = "edit +" . matchList[2] . " " . matchList[1]
        let status = 1
    endif

    return status
endfunction

function! s:MSVCStack()
    let status = 0
    let matchList = matchlist( s:fileLine, '.*\.dll!\([^(]*\).* Line \([0-9]*\).*' )

    if len(matchList)
        let s:cmd = "tag " . matchList[1]
        let status = 1
    endif

    return status
endfunction

" ----- Emulate 'gf' but recognize :line format -----
" Code from: https://github.com/amix/open_file_under_cursor.vim
function! s:GotoLocalFile()
    let curword = expand("<cfile>")
    if (strlen(curword) == 0)
        return
    endif
    let matchstart = match(curword, ':\d\+$')
    if matchstart > 0
        let pos = '+' . strpart(curword, matchstart+1)
        let fname = strpart(curword, 0, matchstart)
    else
        let pos = ""
        let fname = curword
    endif

    " check exists file.
    if filereadable(fname)
        let fullname = fname
    else
        " try find file with prefix by working directory
        let fullname = getcwd() . '/' . fname
        if !filereadable(fullname)
            " the last try, using current directory based on file opened.
            let fullname = expand('%:h') . '/' . fname
        endif
    endif

    " Use 'find' so path is searched like 'gf' would
    let s:cmd ='find ' . pos . ' ' . fname
    return 1
endfunction

let s:parsers = [
    \ function("s:IncludeFrom"),
    \ function("s:MSCEError"),
    \ function("s:GrepOutput"),
    \ function("s:IncludeStatement"),
    \ function("s:MSVCStack"),
    \ function("s:GotoLocalFile"),
    \ ]

function! GoToFile()
    let s:fileLine = getline(".")
    let processed = 0
    for P in s:parsers
        if P()
            try
                exec s:cmd
            catch
                echo "Cannot find file."
            endtry
            let processed = 1
            break
        endif
    endfor

    if !processed
        echo "Parsing of the current line failed."
    endif
endfunction

" Override vim commands 'gf', '^Wf', '^W^F'
nnoremap gf :call GoToFile()<CR>

" Code from: https://vi.stackexchange.com/a/14313
func! GetModifiedBufferCount()
    return len(filter(getbufinfo(), 'v:val.changed == 1'))
endfunc

function! SearchDocs(...)
    let wordUnderCursor = a:0 > 0 ? a:1 : expand('<cword>')
    let filetype = &filetype
    if (filetype == 'qml')
        let helpLink = 'doc.qt.io'
        " Add QML suffix to improve the search. Sometimes we may hit reults
        " for C++ class with the same name.
        let wordUnderCursor .= ' QML'
    elseif (filetype == 'vim')
        execute 'help ' . wordUnderCursor
        return
    elseif (filetype == 'cpp')
        let helpLink = match(wordUnderCursor, 'Q') == 0 ? 'doc.qt.io' : 'en.cppreference.com'
    elseif (filetype == 'python')
        let helpLink = 'docs.python.org/3/'
    elseif (filetype == 'javascript')
        let helpLink = 'developer.mozilla.org/en-US/docs/Web/JavaScript/Reference'
    else
        let helpLink = ''
    endif

    if (len(helpLink) > 0)
        let searchLink = 'https://duckduckgo.com/?q=\' . wordUnderCursor .  ' site:' . helpLink
    else
        let searchLink = 'https://duckduckgo.com/?q=' . wordUnderCursor
    endif

    if has('win32')
        call execute('!explorer "' . searchLink . '"')
    else
        call execute('!open "' . searchLink . '"')
    endif
endfunction

function! CheckBackSpace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:vimrc_review_base_branch = ""
function! StartReview(...)
    let l:baseBranch = ""
    if (strlen(g:vimrc_review_base_branch) > 0)
        let l:baseBranch = g:vimrc_review_base_branch
    else
        if (a:0 == 0)
            echoerr "Base branch is required."
            return
        endif

        let l:baseBranch = a:1
        let g:vimrc_review_base_branch = a:1
    endif

    echom l:baseBranch
    execute 'args `git diff --name-only ' . l:baseBranch . '`'
endfunction

function! ReviewDiff()
    if (strlen(g:vimrc_review_base_branch) == 0)
        echoerr "Start a review using StartReview()"
        return
    endif

    execute 'Gdiff ' . g:vimrc_review_base_branch
endfunction

" Toggles the quickfix window.
function! ToggleQuickFix()
    let tpbl = []
    call extend(tpbl, tabpagebuflist(tabpagenr()))

    let l:quickFixOpen = v:false
    for idx in tpbl
        if getbufvar(idx, "&buftype", "ERROR") == "quickfix"
            let l:quickFixOpen = v:true
            break
        endif
    endfor

    if l:quickFixOpen
        cclose
    else
        copen
    endif
endfunction

function! ToggleColorColumn(col)
    let columns = split(&colorcolumn, ",")
    if a:col == -1
        let columns = [columns[0]]
    else
        let found = index(columns, string(a:col))
        if found > -1
            call remove(columns, found)
        else
            call add(columns, a:col)
        endif
    endif

    execute "set colorcolumn=" . join(columns, ",")
endfunction
