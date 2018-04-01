let s:cpo = &cpo
set cpo&vim

if !exists('g:json_ponyfill#test') || g:json_ponyfill#test == 0
  finish
endif
for f in split(glob('autoload/**/*.vim'), "\n")
  let varparts = []
  let subnames = split(f, '\v(/|\\)')[1:]
  if len(subnames) > 1
    call extend(varparts, subnames[ : len(subnames) - 2])
  endif
  call add(varparts, fnamemodify(subnames[len(subnames) - 1], ':t:r'))
  try
    execute printf('let s:_dummy = %s#_dummy', join(varparts, '#'))
  catch /^Vim(let):/
    " NOP
  catch
    echoerr v:exception
  endtry
  execute printf('source %s', f)
  unlet! s:_dummy
endfor

let s:nest = 1
let s:indent = repeat("\u0020", 2)
function! s:passing(it, time)
  echohl Statement
  echomsg printf("%s\u2713 %s (%ssec)", repeat(s:indent, s:nest),
     \ a:it, substitute(reltimestr(a:time), '^\s*', '', ''))
  echohl None
endfunction
function! s:failing(it, actual, expect)
  echohl WarningMsg
  echomsg printf('%sx %s', repeat(s:indent, s:nest), a:it)
  echomsg printf('%s  expect: %s', repeat(s:indent, s:nest), string(a:expect))
  echomsg printf('%s  actual: %s', repeat(s:indent, s:nest), string(a:actual))
  echohl None
endfunction
function! s:shouldeql(it, actual, expect, time)
  if a:actual == a:expect
    call s:passing(a:it, a:time)
  else
    call s:failing(a:it, a:actual, a:expect)
  endif
endfunction
function! s:itshouldeql(it, input, expect)
  let start = reltime()
  call s:shouldeql(a:it, a:input, a:expect, reltime(start))
endfunction
function! s:describe(desc)
  echomsg repeat(s:indent, s:nest) a:desc
  let s:nest += 1
endfunction
function! s:enddescribe()
  let s:nest -= 1
endfunction

call s:describe("json_ponyfill#stack")
  let s:stack = [ "foo", "bar" ]
  call s:itshouldeql("json#stackpeek",
    \ json_ponyfill#stack#peek(s:stack),
    \ "bar")

  let s:stack = [ "foo", "bar" ]
  call json_ponyfill#stack#push(s:stack, "baz")
  call s:itshouldeql("json_ponyfill#stack#push",
    \ json_ponyfill#stack#peek(s:stack),
    \ "baz")

  let s:stack = [ "foo", "bar" ]
  call s:itshouldeql('json_ponyfill#stack#pop #1',
    \ json_ponyfill#stack#pop(s:stack),
    \ "bar")
  call s:itshouldeql('json_ponyfill#stack#pop #2',
    \ len(s:stack),
    \ 1)
  call s:itshouldeql('json_ponyfill#stack#pop #3',
    \ json_ponyfill#stack#pop(s:stack),
    \ "foo")
  call s:itshouldeql('json_ponyfill#stack#pop #4',
    \ len(s:stack),
    \ 0)
  call s:itshouldeql('json_ponyfill#stack#pop #5',
    \ json_ponyfill#stack#pop(s:stack),
    \ "")
  unlet! s:stack
call s:enddescribe()

call s:describe("json_ponyfill#native#json_encode")
  call s:itshouldeql('vim escape conviction #1',
    \ "\\n", '\n')
  call s:itshouldeql('vim escape conviction #2',
    \ substitute('foo\n', '\n', '\\n', 'g'), 'foo\n')
  call s:itshouldeql('encode string',
    \ json_ponyfill#native#json_encode("foo\n"), "\"foo\\n\"")
  call s:itshouldeql('encode number #1',
    \ json_ponyfill#native#json_encode(12), '12')
  call s:itshouldeql('encode number #2',
    \ json_ponyfill#native#json_encode(12.345), '12.345')
  call s:itshouldeql("encode array",
    \ json_ponyfill#native#json_encode(['foo', 'bar', 'baz']),
    \ '["foo","bar","baz"]')
  call s:itshouldeql("encode nested array",
    \ json_ponyfill#native#json_encode(['foo', 'bar', ['baz', 'foobar']]),
    \ '["foo","bar",["baz","foobar"]]')
  call s:itshouldeql("encode empty object",
    \ json_ponyfill#native#json_encode({}),  "{}")
  call s:itshouldeql("encode simple object",
    \ json_ponyfill#native#json_encode({"foo": "bar"}), '{"foo":"bar"}')
  call s:itshouldeql("encode nested object",
    \ json_ponyfill#native#json_encode({
      \ 'foo': ['bar', [1, 2, 3] , { 'foobar': 12.345 }]
      \ }),
    \ '{"foo":["bar",[1,2,3],{"foobar":12.345}]}')

  call s:itshouldeql("decode string",
    \ json_ponyfill#native#json_decode('"foo"'),
    \ "foo")
  call s:itshouldeql("decode number #1",
    \ json_ponyfill#native#json_decode("12"), 12)
  call s:itshouldeql("decode number #2",
    \ json_ponyfill#native#json_decode("12.345"),
    \ 12.345)
  call s:itshouldeql("decode boolean #1",
    \ json_ponyfill#native#json_decode("true"), 1)
  call s:itshouldeql("decode boolean #2",
    \ json_ponyfill#native#json_decode("false"), 0)
  call s:itshouldeql("decode array #1",
    \ json_ponyfill#native#json_decode('["foo", "bar", "baz"]'),
    \ ["foo", "bar", "baz"])
  call s:itshouldeql("decode array #2",
    \ json_ponyfill#native#json_decode('[1, 2, 3]'),
    \ [1, 2, 3])
  call s:itshouldeql("decode object #1",
    \ json_ponyfill#native#json_decode('{ "foo": "bar" }'),
    \ { "foo": "bar" })
  call s:itshouldeql('decode object #2',
    \ json_ponyfill#native#json_decode('{ "foo": { "bar": "baz" } }'),
    \ { "foo": { "bar": "baz" } })
  call s:itshouldeql('decode object #3',
    \ json_ponyfill#native#json_decode('{ "foo" : { "bar" : "baz", "baz": [ 1, 2, 3 ] } }'),
    \ { "foo": { "bar": "baz", "baz": [1, 2, 3] } })

  let throwexception = 0
  try
    call json_ponyfill#native#json_decode('{ "foo" ":" "baz" }')
  catch /^colon is expected/
    let throwexception = 1
  finally
    call s:itshouldeql("decode object (Failing)",
      \ throwexception, 1)
  endtry
call s:enddescribe()

call s:describe("json_ponyfill#python")
if json_ponyfill#python#ready()
  call s:itshouldeql('decode', json_ponyfill#python#json_decode('{ "foo": "bar" }'), { "foo": "bar" })
  call s:itshouldeql('encode', json_ponyfill#python#json_encode({ "foo": "bar" }), '{"foo": "bar"}')
else
  s:failing('No python or json module. Skipped python testcase.', '-python', '+python')
endif
call s:enddescribe()

let &cpo = s:cpo
unlet s:cpo
