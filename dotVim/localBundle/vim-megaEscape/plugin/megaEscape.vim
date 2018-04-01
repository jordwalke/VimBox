function! UnhighlightMerlinIfDefined()
  " Why is this echo needed?
  echo ''
  if exists(":MerlinClearEnclosing")
    execute "MerlinClearEnclosing"
  endif
endfunction

command! -nargs=* MegaEscapeUnhilightEverything :call UnhighlightMerlinIfDefined(<f-args>)

" The following config in settings.gui.json:
" "normal @silent:<esc>": "keys::nohlsearch<return>:MegaEscapeUnhilightEverything<return><esc>"
" Has problems when in terminal vim. The following supposedly fixes it but I
" still saw issues. Worth trying in modern vim.
"
" augroup no_highlight
"   autocmd TermResponse * nnoremap <silent> <esc> :nohlsearch<return>:MegaEscapeUnhilightEverything<return><esc>
" augroup END

augroup incsearch-keymap
    autocmd!
    autocmd VimEnter * call s:incsearch_keymap()
augroup END
function! s:incsearch_keymap()
  if exists('g:loaded_incsearch')
    IncSearchNoreMap <c-l> <Esc>
    IncSearchNoreMap <c-l> <C-c>
  endif
endfunction
