function! s:VSplitIntoNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    vsp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc


function! s:VSplitIntoPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    vsp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc
command! VSplitIntoPrevTab call s:VSplitIntoPrevTab()
command! VSplitIntoNextTab call s:VSplitIntoNextTab()


"================ FINDING FILES =========================
" http://robertmarkbramprogrammer.blogspot.com/2008/12/searching-files-within-vim-and-opening.html
" http://vim.wikia.com/wiki/Display_shell_commands'_output_on_Vim_window Run a
" shell command and open results in a horizontal split
command! -complete=file -nargs=+ Split call s:RunShellCommandInSplit(<q-args>)
function! s:RunShellCommandInSplit(cmdline)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1,a:cmdline)
  call setline(2,substitute(a:cmdline,'.','=','g'))
  execute 'silent $read !'.escape(a:cmdline,'%#')
  setlocal nomodifiable
  1
endfunction

" Copy of the above that opens results in a new tab.
function! s:RunShellCommandInTab(cmdline)
  tabnew
  setlocal buftype=nofile nobuflisted noswapfile nowrap
  call setline(1,a:cmdline)
  call setline(2,substitute(a:cmdline,'.','=','g'))
  execute 'silent $read !'.escape(a:cmdline,'%#')
  setlocal nomodifiable
  1
endfunction
" Issue a find command using regex and open results in a new tab.
command! -complete=file -nargs=+ Tab call s:RunShellCommandInTab(<q-args>)
command! -complete=file -nargs=+ Grep call s:RunShellCommandInTab('grep -r '.<q-args>.' .')
command! -complete=file -nargs=+ Find call s:RunShellCommandInTab('find . -iregex '.<q-args>)

" http://stackoverflow.com/questions/5303417/how-can-i-reuse-the-same-vim-window-buffer-for-command-output-like-the-help-wi
" Doesn't do what you want:
" command! -complete=file -nargs=+ Output call s:OutputIt(<q-args>)
" let s:outputbufnr=-1
" function! s:OutputIt(cmdline)
"   " move to preview window and create one if it doesn't yet exist
"   silent! wincmd P
"   if ! &previewwindow
"     " use 'new' instead of 'vnew' for a horizontal split
"     vnew
"     set previewwindow
"   endif
"   silent! r! ls
" endfunction

"========== Windows ===================================
if has("gui_win32")
  source ~/.vim/windowsCustomFunctions.vim
endif

