" http://vim.wikia.com/wiki/Get_shortened_messages_from_using_echomsg
function! s:ShortEcho(msg)
  let saved=&shortmess
  set shortmess+=T
  exe "norm :echomsg a:msg\n"
  let &shortmess=saved
endfunction

function! s:ShortError(msg)
  echohl Error
  let saved=&shortmess
  set shortmess+=T
  exe "norm :echomsg a:msg\n"
  let &shortmess=saved
  echohl none
endfunction

" From answer here: https://vi.stackexchange.com/questions/1942/how-to-execute-shell-commands-silently
fun! s:RunItRunCmdOrShowErrorNicely(cmd)
    silent let f = systemlist(a:cmd)
    if v:shell_error
      call VimBoxUserMessageError(join(f, '   '))
      return
    else
      call VimBoxUserMessageSuccess(join(f, '   '))
    endif
endfun

" TODO: Have this resolve the project root from the current file.
command! -nargs=+ DoRunCmdOrShowErrorNicelyCmd call s:RunItRunCmdOrShowErrorNicely(<q-args>)

nmap <script> <silent> <D-r> :DoRunCmdOrShowErrorNicelyCmd ./runFromEditor.sh<CR>
