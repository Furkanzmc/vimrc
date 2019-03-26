"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set font according to system
try
    if has("mac") || has("macunix")
        set gfn=Fira\ Code:h12
    elseif has("win16") || has("win32")
        set gfn=Fira\ Code:h11
    elseif has("linux")
        set gfn=Fira\ Code 11
    elseif has("unix")
        set gfn=Monospace\ 11
    endif
catch
endtry

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Colorscheme
set background=dark

" Highlight trailing spaces.
highlight ExtraWhitespace ctermbg=196 guibg='#EB5A2D'
match ExtraWhitespace /\s\+$/

autocmd BufWinEnter * highlight ExtraWhitespace ctermbg=196 guibg='#EB5A2D'
autocmd InsertEnter * highlight ExtraWhitespace ctermbg=196 guibg='#EB5A2D'
autocmd InsertLeave * highlight ExtraWhitespace ctermbg=196 guibg='#EB5A2D'
autocmd BufWinLeave * highlight ExtraWhitespace ctermbg=196 guibg='#EB5A2D'

autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fast editing and reloading of vimrc configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd! bufwritepost ~/.vim_runtime/my_configs.vim source ~/.vim_runtime/my_configs.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h ~/
cno $d ~/Desktop/
cno $c <C-\>eCurrentFileDir("")<cr>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Map ½ to something useful
map ½ $
cmap ½ $
imap ½ $

" Sort the selected lines according to their lengths.
command! -range SortLength :call setline("'<", sort(getline("'<", "'>"), "CompareLength"))

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i

vmap <leader>s :call VisualSelection('search', '')<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use ripgrep over grep, if possible
if executable('rg')
   " Use rg over grep
   set grepprg=rg\ --vimgrep\ $*
   set grepformat=%f:%l:%c:%m
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

" Taking from here: https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
" Allows running macros only on selected files.
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
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

function! ReplaceInCurrentDir(from, to)
   execute ':args `rg -l -F '. a:from .' ./` | argdo %s/'. a:from .'/'. a:to .'/g'
endfunction

" Buffer related code from https://stackoverflow.com/a/4867969
function! GetBufferList()
    return filter(range(1,bufnr('$')), 'buflisted(v:val)')
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

command! -nargs=1 Bdeletes call WipeMatchingBuffers('<args>')

" Delete all hidden buffers
" From https://github.com/zenbro/dotfiles/blob/master/.nvimrc
command! Bdhidden call DeleteHiddenBuffers()
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
