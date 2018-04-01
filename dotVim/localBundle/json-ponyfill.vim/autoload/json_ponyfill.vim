let s:cpo = &cpo
set cpo&vim

function! json_ponyfill#json_decode(val, ...)
  let option = len(a:000) > 0 ? a:000[0] : {}
  if has_key(option, 'python')
    \ && option.python
    \ && json_ponyfill#python#ready()
    return json_ponyfill#python#json_decode(a:val)
  endif
  return json_ponyfill#native#json_decode(a:val, option)
endfunction

function! json_ponyfill#json_encode(val, ...)
  let option = len(a:000) > 0 ? a:000[0] : {}
  if has_key(option, 'python')
    \ && option.python
    \ && json_ponyfill#python#ready()
    return json_ponyfill#python#json_encode(a:val)
  endif
  return json_ponyfill#native#json_encode(a:val, option)
endfunction

let &cpo = s:cpo
unlet s:cpo
