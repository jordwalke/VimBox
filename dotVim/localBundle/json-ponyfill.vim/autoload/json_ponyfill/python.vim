let s:cpo = &cpo
set cpo&vim

function! json_ponyfill#python#ready()
  if !has('python')
    return 0
  endif
python << endpython
import vim;
try:
  __import__('json');
  vim.command('let ready = 1')
except ImportError:
  vim.command('let ready = 0')
endpython
  return ready
endfunction

function! json_ponyfill#python#json_decode(value)
  let bind = {}
python << endpython
import vim;
import json;
bind = vim.bindeval('bind');
bind.update({'value': json.loads(vim.eval('a:value'))});
endpython
  return bind.value
endfunction

function! json_ponyfill#python#json_encode(value)
  let bind = {}
python << endpython
import vim;
import json;
bind = vim.bindeval('bind');
bind.update({'value': json.dumps(vim.eval('a:value'))});
endpython
  return bind.value
endfunction

let &cpo = s:cpo
unlet s:cpo
