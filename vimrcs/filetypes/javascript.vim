setlocal foldenable
setlocal nocindent

imap <buffer> <c-t> $log();<esc>hi
imap <buffer> <c-a> alert();<esc>hi
