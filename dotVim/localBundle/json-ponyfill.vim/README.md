# json-ponyfill.vim

Provide `json_decode` and `json_encode` to the former version of VIM.

```viml
function! s:json_decode(json)
  if !exists("*json_decode")
    return json_ponyfill#json_decode(a:json)
  endif
  return json_decode(a:json)
endfunction

function! s:json_encode(json)
  if !exists("*json_encode")
    return json_ponyfill#json_encode(a:json)
  endif
  return json_encode(a:json)
endfunction
```

## Install (Pathogen)

```bash
git clone https://github.com/retorillo/json-ponyfill.vim ~/.vim/bundle/json-ponyfill.vim
```

## Performance problem and workarounds

`json_ponyfill#json_decode` and `json_ponyfill#json_encode` will take a long
time working with large JSON.

Of course my code may be not sophisticated, but originally Vim Script is not
good for large processing.

Consider to use the following workarounds:

### Using python if possible

Use `json_ponyfill#json_decode(json, { 'python': 1 })`
to use python if possible.

Python can process faster than Vim Script.

### Displaying progress bar

Use `json_ponyfill#json_decode(json, { 'progress': 1 })`
to display progress bar like below:

```
json_decode  50% [=========================.........................]
```

**NOTE:** Progress bar use `redraw` command to refresh itself. `redraw` command
wipe previously printed all echo message out.  See `:h redraw`, `:h messages`,
`:h echomsg`, and `:h echoerr` to learn more.

### Combining the above workarounds

Of course, the above options can be combined like:
`json_ponyfill#json_decode(json, { 'progress': 1, 'python': 1 }`.
But note that progress option will be ignored if python is available.

## Unit testing (For plugin developers)

`test/test.vim` is a bit useful snippet for unit testing.

```
:let g:json_ponyfill = 1 | source test/test.vim
```

## License

MIT License

(C) 2016-2017 Retorillo
