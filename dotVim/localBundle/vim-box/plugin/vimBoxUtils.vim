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

" Note about platform detection. You can use 'has()' for the following:
" gui_running   A GUI is running (MacVim, or windows/linux Gvim shell.)
" macunix       Macintosh version of Vim, using Unix files (OS-X).
" unix          Unixy versions of Vim: MacVim, Mac CLI, linux, or cygwin.
" win32         Actual windows vim.
" win32unix     Win32 version of Vim, using Unix files (Cygwin)
"
" Note: The Vim.exe was installed via the Windows GVim installer, but a
" different command line binary started from windows Cmd.exe.
"
" Note: Notice that `macunix` behaves strangely - it is false for command line
" stock vim but true for anything build for MacVim even if on CLI. Same with
" 'mac'. There's no great way to tell if you're running "on a mac" besides
" `uname`. I've seen problems running any `system()` command in cygwin vim
" though.
"
" https://vi.stackexchange.com/questions/2572/detect-os-in-vimscript/2577#2577
"
" |                    | MacVimGUI | MacVim(CLI)| osx vim      | gvim.exe   | vim.exe    | cygwin   |
" |--------------------|-----------|------------|--------------|------------|------------|----------|
" | Description:       | OSX UI App| MacVim CLI | stock CLI vim| Windows UI | WindowsCLI | CygwinVim|
" | has('gui'):        | 1         | 1          | 0            | 1          | 0          | 0        |
" | has('gui_running'):| 1         | 0          | 0            | 1          | 0          | 0        |
" | has('unix'):       | 1         | 1          | 1            | 0          | 0          | 1        |
" | has('win32unix'):  | 0         | 0          | 0            | 0          | 0          | 1        |
" | has('macunix'):    | 1         | 1          | 0            | 0          | 0          | 0        |
" | has('win32'):      | 0         | 0          | 0            | 1          | 1          | 0        |
" | has('mac'):        | 1         | 1          | 0            | 0          | 0          | 0        |
" | has('gui_mac'):    | 0         | 0          | 0            | 0          | 0          | 0        |

" g:vimBoxOs: OS the end use is running (ignoring if they are in WSL or VM etc.)
"
"   - "osx"
"   - "linux"
"   - "windows"
"
" g:vimBoxGui
"
"   - "gui" Running in some GUI app (MacVim, Oni, GVim)
"   - "term" Running in a terminal
"
" g:vimBoxSupportsUnix
"   - 1 Supports unix APIs (running on Mac/Linux or in a windows env like Cygwin)
"   - 0 Doesn't support unix APIs.
if !exists("g:vimBoxOs")
  if has("win64") || has("win32") || has("win16")
    let g:vimBoxOs = "windows"
  else
    if has("macunix")
      let g:vimBoxOs = "osx"
    else
      " Cygwin gets wrapped up in using uname (sometimes fails with /tmp dir
      " errors).
      if has("win32unix")
        let g:vimBoxOs = "windows"
      else
        " Kind of sucks that we have to spawn a completely new process at
        " startup time just to check the os - we should allow invokers to
        " supply this.
        let uname = substitute(system('uname'), '\n', '', '')
        let g:vimBoxOs = uname == 'Darwin' ? 'osx' : 'linux'
      endif
    endif
  endif
endif

if !exists("g:vimBoxVimType")
  if has("nvim")
    let g:vimBoxVimType = 'neovim'
  else
    let g:vimBoxVimType = 'regularvim'
  endif
endif

if !exists("g:vimBoxGui")
  let g:vimBoxGui = has('gui_running') || exists('g:gui_oni') ? 'gui' : 'term'
endif

if !exists("g:vimBoxSupportsUnix")
  let g:vimBoxSupportsUnix = has('unix')
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
