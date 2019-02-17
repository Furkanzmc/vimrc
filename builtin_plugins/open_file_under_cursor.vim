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
	let matchList = matchlist( s:fileLine, '^#[ 	]*include[ 	]*["<]\([^">]*\)' )

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
