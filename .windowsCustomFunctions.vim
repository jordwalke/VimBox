"========== Windows ===================================

let g:isWin32Full = 0
function! ToggleFullScreenAndRememberIt()
  call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)
  let g:isWin32Full = g:isWin32Full ? 0 : 1
endfunction

" Requires proper AutoHotkey.ahk
nmap <F15> <Esc>:call ToggleFullScreenAndRememberIt()<CR>
imap <F15> <Esc>:call ToggleFullScreenAndRememberIt()<CR>
cmap <F15> <Esc>:call ToggleFullScreenAndRememberIt()<CR>a
vmap <F15> <Esc>:call ToggleFullScreenAndRememberIt()<CR>

" Combining the following articles.
" http://vim.wikia.com/wiki/Change_font_size_quickly
" http://vim.wikia.com/wiki/Change_guifont_to_see_more_of_your_file
" In AutoHotkey file add:
" #IfWinActive ahk_class Vim
"   !=::Send ^!#{i} ; increase
"   !-::Send ^!#{d} ; decrease
" #IfWinActive
function! ScaleFontUp()
  let &guifont = substitute(
        \ &guifont,
        \ ':h\zs\d\+',
        \ '\=eval(submatch(0)+1)',
        \ 'g')
  if g:isWin32Full
    call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)
    call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)
  endif
endfunction

function! ScaleFontDown()
  let &guifont = substitute(
        \ &guifont,
        \ ':h\zs\d\+',
        \ '\=eval(submatch(0)-1)',
        \ 'g')
  if g:isWin32Full
    call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)
    call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)
  endif
endfunction

imap <C-Down> <Esc>:call ScaleFontDown()<CR>a
imap <C-Up> <Esc>:call ScaleFontUp()<CR>a
nmap <C-Down> :call ScaleFontDown()<CR>
nmap <C-Up> :call ScaleFontUp()<CR>
