let s:cpo = &cpo
set cpo&vim

function! json_ponyfill#stack#push(list, item)
  call add(a:list, a:item)
endfunction
function! json_ponyfill#stack#peek(list)
  if !empty(a:list)
    return get(a:list, len(a:list) - 1)
  endif
  return ""
endfunction
function! json_ponyfill#stack#pop(list)
  if !empty(a:list)
    let peek = json_ponyfill#stack#peek(a:list)
    call remove(a:list, len(a:list) - 1)
    return peek
  endif
  return ""
endfunction

let &cpo = s:cpo
unlet s:cpo
