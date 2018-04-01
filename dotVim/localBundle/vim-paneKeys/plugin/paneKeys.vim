
" If it's open then just close it else, open it then jump back to prev window.
" NERDTree's default toggle behavior doesn't work like this.  This should also
" work if the explorer was opened with NERDTreeFind
" Toggle doesn't change the working directory of the nerd tree.
function! PaneToggleExplorer()
  if exists(":NERDTree")
    let g:VimSplitBalancerSupress=1
    " Need finally to restore split balancer.
    try
      " If open
      if exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
        execute "NERDTreeToggle"
      else
        execute "NERDTreeToggle"
        wincmd p
      endif
    finally
      let g:VimSplitBalancerSupress=0
    endtry
  endif
endfunction

command! -nargs=* DoToggleExplorer :call PaneToggleExplorer(<f-args>)

" If it's open then just close it else, open it then jump back to prev window.
" NERDTree's default toggle behavior doesn't work like this.  This should also
" work if the explorer was opened with NERDTreeFind
function! PaneFindInExplorer()
  if exists(":NERDTree")
    let g:VimSplitBalancerSupress=1
    " Need finally to restore split balancer.
    try
      execute "NERDTreeFind"
    finally
      let g:VimSplitBalancerSupress=0
    endtry
  endif
endfunction

command! -nargs=* DoFindInExplorer :call PaneFindInExplorer(<f-args>)

function! PaneToggleExplorerFocus()
  if exists(":NERDTree")
    let g:VimSplitBalancerSupress=1
    " Need finally to restore split balancer.
    try
      if &filetype ==# 'nerdtree'
        wincmd p
      else
        execute "NERDTreeFocus"
      endif
    finally
      let g:VimSplitBalancerSupress=0
    endtry
  endif
endfunction

command! -nargs=* DoToggleExplorerFocus :call PaneToggleExplorerFocus(<f-args>)
