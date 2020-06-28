call unite#filters#matcher_default#use(['matcher_fuzzy'])
" :Unite file_rec/async  (searches files async)
" - `toggle` closes existing unite window before opening the new one.
" - `tab` opens in new tab, good for keeping grep results around.
"
" CMD-p style starts in "insert mode"
" The mappings down below make <c-l> (my favorite) a way to always escape out of
" Unite.vim.
" :map <D-p> >Unite buffer file_rec -auto-highlight -toggle
map <D-i> :Unite grep:. -auto-highlight -here -vertical -toggle -no-wrap -no-multi-line -max-multi-lines=1 -wipe -auto-preview<CR>

" Disable AutoComplPop plugin - make sure ACP is loaded before Unite.vim.
" TODO: Disable "space" to "mark" file in output. I use space as a way to switch
" tabs in vim so there is a conflict.
if exists('g:loaded_acp')
  autocmd bufenter unite AcpLock
  autocmd bufleave unite AcpUnlock
endif
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  " Overwrite settings.
  nmap <buffer> <ESC>      <Plug>(unite_exit)
  imap <buffer> <C-l>      <Plug>(unite_exit)
  nmap <buffer> <C-l>      <Plug>(unite_exit)
  imap <buffer> <C-c>      <Plug>(unite_exit)
  nmap <buffer> <C-c>      <Plug>(unite_exit)
  "imap <buffer> jj      <Plug>(unite_insert_leave)
  "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)

  "Changing the deafult tab:
  "<Tab>		i_<Plug>(unite_choose_action)
  imap <buffer> <TAB> <Plug>(unite_insert_leave)
  map <buffer> <s-TAB> <Plug>(unite_insert_enter)
  map <buffer> <TAB> <c-w><c-w>
  map <buffer><c-Cr>		<Plug>(unite_choose_action)
  imap <buffer><c-Cr>		<Plug>(unite_choose_action)
  " Runs "split" action by <C-s>.
  map <silent><buffer><expr> <Cr>  unite#do_action('tabswitch')
  map <silent><buffer><expr> <C-s>  unite#do_action('vsplitswitch')
  map <silent><buffer><expr> <C-h>  unite#do_action('splitswitch')
endfunction"}}}
