" Code initial code belongs to Rudy Wortel

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

function! s:SchemeError()
	let status = 0
	cre = re.compile("^Scheme error in file '([^']*)' on line '([^']*)")
	let matchList = matchlist(s:fileLine, "Scheme error in file '\([^']*\)' on line '\([0-9]*\).*")

	if len(matchList)
		let s:cmd = "edit +" . matchList[2] . " " . matchList[1]
		let status = 1
	endif

	return status
endfunction

let s:parsers = [
	\ function("s:IncludeFrom"),
	\ function("s:MSCEError"),
	\ function("s:GrepOutput"),
	\ function("s:IncludeStatement"),
	\ function("s:MSVCStack"),
	\ function("s:SchemeError"),
	\ ]

function! GoToFile()
	let s:fileLine = getline(".")
	let processed = 0
	for P in s:parsers
		if P()
			exec s:cmd
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
