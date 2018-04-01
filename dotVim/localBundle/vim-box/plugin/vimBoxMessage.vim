" https://stackoverflow.com/questions/33087376/get-the-backtrace-of-a-function-call?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
function! StackTrace(trace)
    return map(split(substitute(a:trace, '^function ', '', ''), '\.\.'), 'substitute(v:val, ''\m\[\d\+\]$'', "", "")')[:-2]
endfunction

function! s:trunc(s, len)
  if len(a:s) < a:len || len(a:s) == a:len
    return a:s
  else
    return strpart(a:s, 0, a:len-2) . '..'
  endif
endfunction

" Shown to user and logged.
function! VimBoxUserMessageError(msg)
  if g:vimBoxIsLoading
    let g:vimBoxErrorsDuringLoad = 1
  endif
  " regular :echomsg doesn't shorten messages with +T
  " but for some reason, with "norm echomsg", it does.
  " The same trick doesn't work for echoerr :(
  let saved=&shortmess
  set shortmess+=T
  let typ1 = type(a:msg)
  let msg = a:msg
  if typ1 != v:t_string
    let msg = string(a:msg)
  endif
  let cols = &columns
  let msgNotif = strpart(s:trunc(msg, cols-1) . '                                                                                                                                                             ', 0, cols-1)
  " :echohl ErrorMsg | echo "Don't panic!" | echohl None
  exe "norm :echohl airline_error | echomsg msgNotif | echohl None\n"
  call VimBoxLog('ERROR', msg)
  let &shortmess=saved
endfunction

" User facing messages. Logged.
" Causes "hit enter" when passing double quoted strings wat1?
function! VimBoxUserMessage(msg)
  let typ = type(a:msg)
  let msg = a:msg
  if typ != v:t_string
    let msg = string(a:msg)
  endif
  let cols = &columns
  " regular :echomsg doesn't shorten messages with +T
  " but for some reason, with "norm echomsg", it does.
  " The same trick doesn't work for echoerr :(
  let saved=&shortmess
  set shortmess+=T
  let msgNotif = strpart(s:trunc(msg, cols-1) . '                                                                                                                                                             ', 0, cols-1)
  exe "norm :echomsg msgNotif\n"
  call VimBoxLog('INFO', msg)
  let &shortmess=saved
endfunction

" Shown to user and logged.
function! VimBoxUserMessageSuccess(msg)
  " regular :echomsg doesn't shorten messages with +T
  " but for some reason, with "norm echomsg", it does.
  " The same trick doesn't work for echoerr :(
  let saved=&shortmess
  set shortmess+=T
  let typ1 = type(a:msg)
  let msg = a:msg
  if typ1 != v:t_string
    let msg = string(a:msg)
  endif
  let cols = &columns
  let msgNotif = strpart(s:trunc(msg, cols-1) . '                                                                                                                                                             ', 0, cols-1)
  " :echohl ErrorMsg | echo "Don't panic!" | echohl None
  exe "norm :echohl airline_a | echomsg msgNotif | echohl None\n"
  call VimBoxLog('SUCCESS', msg)
  let &shortmess=saved
endfunction

" Shown to user and logged.
function! VimBoxUserMessageWarn(msg)
  " regular :echomsg doesn't shorten messages with +T
  " but for some reason, with "norm echomsg", it does.
  " The same trick doesn't work for echoerr :(
  let saved=&shortmess
  set shortmess+=T
  let typ1 = type(a:msg)
  let msg = a:msg
  if typ1 != v:t_string
    let msg = string(a:msg)
  endif
  let cols = &columns
  let msgNotif = strpart(s:trunc(msg, cols-1) . '                                                                                                                                                             ', 0, cols-1)
  " :echohl ErrorMsg | echo "Don't panic!" | echohl None
  exe "norm :echohl airline_warning | echomsg msgNotif\n"
  call VimBoxLog('WARN', msg)
  let &shortmess=saved
endfunction

" Logged messages. Not user facing.
" Use very sparingly, as too many make it hard to find ERRORs in logs.
" Only use when this is something the user's attention should be drawn to when
" browsing logs (things like "starting up vimbox", "initializing new session"
" etc). It also is not very fast, so you'll notice delays in your script.
function! VimBoxLog(...)
  " regular :echomsg doesn't shorten messages with +T
  " but for some reason, with "norm echomsg", it does.
  " The same trick doesn't work for echoerr :(
  let l:fileContents = []
  if file_readable(g:vimBoxLogsCurrentSession)
    let l:fileContents = readfile(g:vimBoxLogsCurrentSession)
  endif
  let l:count = a:0
  if l:count > 1
    let msg = a:2
    let typ2 = type(a:2)
    if typ2 != v:t_string
      let msg = string(a:2)
    endif
    let category = a:1
  else
    let msg = a:1
    let typ1 = type(a:1)
    if typ1 != v:t_string
      let msg = string(a:1)
    endif
    let category = 'INFO'
  endif
  if category != 'INFO' && category != 'SUCCESS' && category != 'ERROR' && category != 'WARN' && category != 'INIT'
    let category = 'UNKONWN'
  endif
  call add(l:fileContents, '['. category . '] ' . msg)
  call writefile(l:fileContents, g:vimBoxLogsCurrentSession)
endfunction
