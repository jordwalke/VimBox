let s:cpo = &cpo
set cpo&vim

let s:ignoreCharacterPattern = "\\s"
let s:keywordStarterPattern = "\\c[_a-z]"
let s:keywordCharacterPattern = "\\c[_a-z0-9]"
let s:numberStarterPattern = "[0-9]"
let s:numberCharacterPattern = "[.0-9]"
let s:floatPattern = "\\v^[0-9]+(\\.[0-9]+)?$"
let s:integerPattern = "\\v^[0-9]+$"

function! s:parsestring(json, from, option)
    if a:json[a:from] != '"'
      throw '" is expected'
    endif
    let l = strlen(a:json)
    let i = a:from + 1
    let e = 0
    let b = ""
    while i < l
      let c = a:json[i]
      if e == 1
        let b = b . c
        let e = 0
      elseif c == '"'
        return { "value": b, "index": i }
      elseif c == "\\"
        let e = 1
      else
        let b = b . c
      endif
      let i = i + 1
    endwhile
    throw '" is unclosed'
endfunction
function! s:parsearray(json, from, option)
  if a:json[a:from] != "["
    throw "[ is expected"
  endif
  let l = strlen(a:json)
  let i = a:from + 1
  let s = []
  while i < l
    let c = a:json[i]
    if c == "]"
      let r = []
      while !empty(s)
        if !empty(r)
          let comma = json_ponyfill#stack#pop(s)
          if comma != ","
            throw ", is expected"
          endif
        endif
        call insert(r, json_ponyfill#stack#pop(s), 0)
      endwhile
      return { "value": r, "index": i }
    elseif c == ","
      call json_ponyfill#stack#push(s, c)
    else
      if matchstr(c, s:ignoreCharacterPattern) == ""
        let p = s:parsejson(a:json, i, a:option)
        call add(s, p["value"])
        let i = p["index"]
      endif
    endif
    let i = i + 1
  endwhile
  throw "] is expected"
endfunction
function! s:parseobject(json, from, option)
  if a:json[a:from] != "{"
    throw "{ is expected"
  endif
  let l = strlen(a:json)
  let i = a:from + 1
  let s = []
  while i < l
    let c = a:json[i]
    if c == "}"
      let r = {}
      while !empty(s)
        if !empty(r)
          let comma = json_ponyfill#stack#pop(s)
          if !comma["token"] || comma["value"] != ","
            throw ", is expected"
          endif
        endif
        if len(s) < 3
          throw "'". json_ponyfill#stack#peek(s)["value"] .'" is unexpeted'
        endif
        let value = json_ponyfill#stack#pop(s)
        let colon = json_ponyfill#stack#pop(s)
        let name = json_ponyfill#stack#pop(s)
        if !colon["token"] || colon["value"] != ":"
          throw 'colon is expected before "'.colon["value"]"\""
        endif
        if name["token"] || type(name["value"]) != 1
          throw name["value"].' is unexpected'
        endif
        let r[name["value"]] = value["value"]
      endwhile
      return { "value": r, "index": i }
    elseif matchstr(c, "[:,]") != ""
      call json_ponyfill#stack#push(s, { "token": 1, "value": c, "index": i })
    else
      if matchstr(c, s:ignoreCharacterPattern) == ""
        let p = s:parsejson(a:json, i, a:option)
        let i = p["index"]
        call json_ponyfill#stack#push(s, { "token": 0, "value": p["value"], "index": i })
      endif
    endif
    let i = i + 1
  endwhile
  throw "} is expected"
endfunction
function! s:parsenumber(json, from, option)
  let l = strlen(a:json)
  let i = a:from
  let b = ""
  while i < l
    let c = a:json[i]
    if matchstr(c, s:numberCharacterPattern) == ""
      break
    endif
    let b = b . c
    let i = i + 1
  endwhile
  if matchstr(b, s:integerPattern) != ""
    let v = str2nr(b)
  elseif matchstr(b, s:floatPattern) != ""
    let v = str2float(b)
  else
    throw "invalid number format: " . b
  endif
  return { "value": v, "index": i - 1 }
endfunction
function! s:parsekeyword(json, from, option)
  let l = strlen(a:json)
  let i = a:from
  let b = ""
  while i < l
    let c = a:json[i]
    if matchstr(c, s:keywordCharacterPattern) == ""
      break
    endif
    let b = b . c
    let i = i + 1
  endwhile
  if matchstr(b, "^true$") != ""
    let v = 1
  elseif matchstr(b, "\\v^(false|null)$") != ""
    let v = 0
  else
    throw "unkown identifier: ".b
  endif
    return { "value": v, "index": i - 1 }
  endif
endfunction

function! s:parsejson(json, from, option)
  let l = strlen(a:json)
  let i = a:from
  if get(a:option, 'progress')
    call s:progressbar(a:from, l, 50)
  endif
  while i < l
    let c = a:json[i]
    if c == "{"
      return s:parseobject(a:json, i, a:option)
    elseif c == "["
      return s:parsearray(a:json, i, a:option)
    elseif c == '"'
      return s:parsestring(a:json, i, a:option)
    elseif matchstr(c, s:numberStarterPattern) != ""
      return s:parsenumber(a:json, i, a:option)
    elseif matchstr(c, s:keywordStarterPattern) != ""
      return s:parsekeyword(a:json, i, a:option)
    else
      if matchstr(c, s:ignoreCharacterPattern) == ""
        throw "unexpected character: ". c . " (index: ". i .")"
      endif
    endif
    let i = i + 1
  endwhile
  throw "invalid format"
endfunction

function! s:unparsenumber(val)
  if type(a:val) == 0
    return printf("%d", a:val)
  else
    return printf("%g", a:val)
  endif
endfunction

function! s:unparsestring(val)
  let sub = {
  \  '"': '\\"',
  \  '\t': '\\t',
  \  '\n': '\\n',
  \  '\r': '\\r',
  \ }
  let r = a:val
  for k in keys(sub)
    let r = substitute(r, k, sub[k], 'g')
  endfor
  return '"'.r.'"'
endfunction

function! s:unparselist(val)
  let r = []
  for i in a:val
    call add(r, s:unparsejson(i))
    unlet i
  endfor
  return join(['[', join(r, ','), ']'], '')
endfunction

function! s:unparsedict(val)
  let r = []
  for k in keys(a:val)
    call add(r, s:unparsestring(k).':'.s:unparsejson(a:val[k]))
  endfor
  return join(['{', join(r, ','), '}'], '')
endfunction
function! s:unparsebool(val)
  if a:val
    return 'true'
  else
    return 'false'
  endif
endfunction

function! s:unparsejson(val)
  let t = type(a:val)
  if t == 0
    return s:unparsenumber(a:val)
  elseif t == 1
    return s:unparsestring(a:val)
  elseif t == 3
    return s:unparselist(a:val)
  elseif t == 4
    return s:unparsedict(a:val)
  elseif t == 5
    return s:unparsenumber(a:val)
  elseif t == 6
    return s:unparsebool(a:val)
  else
    throw 'Cannot be string (vim type: '. val.')'
  endif
endfunction

function! s:progressbar(dividend, divisor, width)
  if a:width == 0
    echo ''
  else
    let rate = a:dividend / (a:divisor * 1.0)
    let head = float2nr(floor(a:width * rate))
    let tail = a:width - head
    echo printf('json_decode %3d%% [%s%s]',
      \ float2nr(rate * 100),
      \ repeat('=', head),
      \ repeat('.', tail))
  endif
  redraw
endfunction

function! json_ponyfill#native#json_encode(val)
  return s:unparsejson(a:val)
endfunction

function! json_ponyfill#native#json_decode(json, ...)
  let option = len(a:000) > 0 && type(a:000[0]) == 4 ? a:000[0] : {}
  let obj = s:parsejson(a:json, 0, option)['value']
  if get(option, 'progress')
    call s:progressbar(0, 0, 0)
  endif
  return obj
endfunction

let &cpo = s:cpo
unlet s:cpo
