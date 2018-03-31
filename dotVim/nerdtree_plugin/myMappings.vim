" NERDTree requires custom mappin reside in a file like this:

" This is broken in newer builds of NerdTree:
" let g:NERDTreeMapOpenInTab='<ENTER>'

let g:NERDTreeCustomReuseWindows = '1'
call NERDTreeAddKeyMap({
       \ 'key': 'w',
       \ 'scope': 'all',
       \ 'callback': 'NERDTreeCustomToggleReuse',
       \ 'quickhelpText': 'Toggle use existing windows' })

function! NERDTreeCustomToggleReuse()
    let g:NERDTreeCustomReuseWindows = g:NERDTreeCustomReuseWindows ? 0 : 1
    echomsg (g:NERDTreeCustomReuseWindows ? 'Reusing' : 'Not reusing') . ' existing windows'
endfunction

call NERDTreeAddKeyMap({
       \ 'key': 'i',
       \ 'scope': 'FileNode',
       \ 'callback': 'NERDTreeCustomOpenSplit',
       \ 'quickhelpText': 'open split reusing if able' })

function! NERDTreeCustomOpenSplit(node)
    call a:node.open({'where': 'h', 'reuse': g:NERDTreeCustomReuseWindows})
endfunction

call NERDTreeAddKeyMap({
       \ 'key': 's',
       \ 'scope': 'FileNode',
       \ 'callback': 'NERDTreeCustomOpenVSplit',
       \ 'quickhelpText': 'open vsplit reusing if able' })


function! NERDTreeCustomOpenVSplit(node)
    call a:node.open({'where': 'v', 'reuse': g:NERDTreeCustomReuseWindows})
endfunction

" Remove standard mapping for "o" to open a file - it's super confusing for that
" same mapping to open directories - you accidentally open files.
call NERDTreeAddKeyMap({
       \ 'key': 'o',
       \ 'scope': 'FileNode',
       \ 'callback': 'NERDTreeCustomNoOpenFile',
       \ 'quickhelpText': 'open vsplit reusing if able' })

function! NERDTreeCustomNoOpenFile(node)
    " call a:node.activate({'where': 'p', 'reuse': g:NERDTreeCustomReuseWindows})
endfunction

if g:vimBoxTabSystem == 'wintabs'
else
  call NERDTreeAddKeyMap({
         \ 'key': '<ENTER>',
         \ 'scope': 'FileNode',
         \ 'callback': 'NERDTreeCustomOpenInTab',
         \ 'quickhelpText': 'open in new tab reusing if able' })
endif

" If you're opening a new instance of vim - hitting enter should open in the
" first buffer not a new tab! #dotherightthing
function! NERDTreeCustomOpenInTab(node)
    call a:node.open({'where': tabpagenr('$') == 1 && winnr('$') == 1 ? 'p' : 't', 'reuse': g:NERDTreeCustomReuseWindows })
endfunction

call NERDTreeAddKeyMap({
       \ 'key': 'T',
       \ 'scope': 'FileNode',
       \ 'callback': 'NERDTreeCustomOpenInTabSilent',
       \ 'quickhelpText': 'open in new background tab reusing if able' })

function! NERDTreeCustomOpenInTabSilent(node)
    call a:node.open({'where': 't', 'stay': 1, 'reuse': g:NERDTreeCustomReuseWindows})
endfunction
