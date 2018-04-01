" Inspired from ctrl-p similar utilities
function! _VimBoxShellSlash()
  let l:forwardSlash = '/'
  let l:backSlash = '\'
  return &ssl || !exists('+ssl') ? l:forwardSlash : l:backSlash
endfunction
let g:slash = _VimBoxShellSlash()
function! _VimBoxSlashFor(...)
  return ( a:0 ? a:1 : getcwd() ) !~ '[\/]$' ? g:slash : ''
endf
function! EnsureSlash(first)
  return a:first . _VimBoxSlashFor(a:first)
endfunction
" Join first with second, where second is not a directory
function! PathJoinFile(first, second)
  return a:first . _VimBoxSlashFor(a:first) . a:second
endfunction
" Join first with second, where second is a directory and will be reflected as
" such with a trailing slash.
function! PathJoinDir(first, second)
  return a:first . _VimBoxSlashFor(a:first) . a:second . _VimBoxSlashFor(a:second)
endfunction

if v:version >= 704
  function! GetWinVar(win, k, default)
    return getwinvar(a:win, a:k, a:default)
  endfunction
else
  function! GetWinVar(win, k, default)
    let allVals = getwinvar(a:win, '')
    return get(allVals, a:k, a:default)
  endfunction
endif

" https://vi.stackexchange.com/questions/2572/detect-os-in-vimscript?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
" Sets the g:vimBoxOs to one of (osx, linux, windows)
if !exists("g:vimBoxOs")
  if has("win64") || has("win32") || has("win16")
    let g:vimBoxOs = "windows"
  else
    let uname = substitute(system('uname'), '\n', '', '')
    let g:vimBoxOs = uname == 'Darwin' ? 'osx' : 'linux'
  endif
endif

if !exists("g:vimBoxGui")
  let g:vimBoxGui = has('gui_running') || exists('g:gui_oni') ? 'gui' : 'term'
endif

" https://vi.stackexchange.com/a/2559
function! VimBoxIsStartScreen()
  let isOnlyWindow = winnr() == winnr('$')
  if !isOnlyWindow
    return 0
  endif
  if @% == ""
    " No filename for current buffer
    return 1
  elseif filereadable(@%) == 0
    " File doesn't exist yet
    return 1
  elseif line('$') == 1 && col('$') == 1
    " File is empty
    return 1
  endif
endfunction


" If in a fresh vim instance, will split all the config files into their own
" split, then close the empty starting window. Otherwise, just splits
" everything.
function! VimBoxShowInSplits(fullPaths, readonly)
  let freshVim = VimBoxIsStartScreen()
  let first = 1
  for path in reverse(a:fullPaths)
    if file_readable(expand(path))
      if (freshVim && first)
        execute "vsplit " . path
        if a:readonly
          execute "set readonly"
        endif
        execute "wincmd p"
        execute "hide"
      elseif (freshVim && !first)
        execute "vsplit " . path
        if a:readonly
          execute "set readonly"
        endif
      elseif (!freshVim && first)
        execute "vsplit " . path
        if a:readonly
          execute "set readonly"
        endif
      else " !freshVim && !first
        execute "vsplit " . path
        if a:readonly
          execute "set readonly"
        endif
      endif
    endif
    let first = 0
  endfor
endfunction
