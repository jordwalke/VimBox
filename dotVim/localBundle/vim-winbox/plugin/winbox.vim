function! WinBoxToggleFullScreen()
  exec "Fullscreen"
endfunction

" Combining the following articles.
" http://vim.wikia.com/wiki/Change_font_size_quickly
" http://vim.wikia.com/wiki/Change_guifont_to_see_more_of_your_file
" In AutoHotkey file add:
" 
"   #IfWinActive ahk_class Vim
"     !=::Send ^{Up}
"     !-::Send ^{Down}
"   #IfWinActive
" 
" Because remapping control+equal isn't possible in vim.
function! WinBoxIncreaseFont()
  let &guifont = substitute(&guifont, ':h\zs\d\+', '\=eval(submatch(0)+1)', 'g')
  if xolox#shell#is_fullscreen()
    exec "Fullscreen"
    exec "Fullscreen"
  endif
endfunction

function! WinBoxDecreaseFont()
  let &guifont = substitute(&guifont, ':h\zs\d\+', '\=eval(submatch(0)-1)', 'g')
  if xolox#shell#is_fullscreen()
    exec "Fullscreen"
    exec "Fullscreen"
  endif
endfunction
