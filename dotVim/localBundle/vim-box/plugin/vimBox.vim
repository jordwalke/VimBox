function! s:VimBoxSplitSettings(rootDir, readonly)
  let files = []
  for filename in VimBoxSearchSettingsFiles()
    let fullPath = PathJoinFile(a:rootDir, filename)
    call add(files, fullPath)
  endfor
  call VimBoxShowInSplits(files, a:readonly)
endfunction

" " Where Cache Files Should Be Stored: (Default $HOME/.cache):
" let g:vimBoxXdgCacheDir = exists('$XDG_CACHE_HOME') ? PathJoinDir($XDG_CACHE_HOME, 'vim-box') : PathJoinDir(g:vimBoxDefaultCacheDir, 'vim-box')
" " Where User Specific Data Files Should Be Written: (undo/backup files) (Default $HOME/.local/share):
" let g:vimBoxXdgDataDir = exists('$XDG_DATA_HOME') ? PathJoinDir($XDG_DATA_HOME, 'vim-box') : PathJoinDir(g:vimBoxDefaultDataDir, 'vim-box')
" " Where User Specific Configuration Should Be Stored: (Default $HOME/.config)
" let g:vimBoxXdgConfigDir = exists('$XDG_CONFIG_HOME') ? PathJoinDir($XDG_CONFIG_HOME, 'vim-box') : PathJoinDir(g:vimBoxDefaultConfigDir, 'vim-box')
"
" " TODO: This should be sourced from the location of current vim script so that
" " you can use VimBox without having to install it over your old vim install.
" let g:vimBoxUndoDir = PathJoinDir(g:vimBoxXdgDataDir, 'undo')
" let g:vimBoxSessionDir = PathJoinDir(g:vimBoxXdgDataDir, 'vim_sessions')
" let g:vimBoxLogsDir = PathJoinDir(g:vimBoxXdgDataDir, 'logs')
" let g:vimBoxPluginInstallDir = PathJoinFile(g:vimBoxXdgDataDir, 'bundle')


function! s:VimBoxReportLoadErrors()
  if g:vimBoxErrorsDuringLoad
    call VimBoxUserMessageError("Error During Initialization. See error in :Logs")
  endif
endfunction

" Less important, more for debugging and exploring
command! -nargs=0 VimBoxRc :execute 'e ' . g:vimBoxGeneratedRc
command! -nargs=0 VimBoxLogs :execute 'e +9999999 ' . g:vimBoxLogsCurrentSession
command! -nargs=0 VimBoxSettings :call <SID>VimBoxSplitSettings(g:vimBoxUserPluginDir, 0)
command! -nargs=0 VimBoxLocations :call VimBoxPathsplane()
command! -nargs=0 VimBoxSettingsDefaults :call <SID>VimBoxSplitSettings(PathJoinDir(g:vimBoxStockPluginsDir, 'vim-box'), 1)
command! -complete=color -nargs=? VimBoxSettingsUI :call VimBoxConfigsplain(<q-args>)

command! -complete=customlist,ListConfig -nargs=1 VimBoxGet :call VimBoxSettingUICommand(<q-args>)
fun! ListConfig(A,L,P)
  let ret = []
  for key in keys(g:vimBox__searchIndex['config'])
    if key =~? a:A
      call add(ret, key)
    endif
  endfor
  return ret
endfun

" Shorter Aliases To Top Level Commands.
command! -nargs=0 Rc :execute 'e ' . g:vimBoxGeneratedRc
command! -nargs=0 Logs :execute 'e +9999999 ' . g:vimBoxLogsCurrentSession
command! -nargs=0 Settings :call <SID>VimBoxSplitSettings(g:vimBoxUserPluginDir, 0)
command! -nargs=0 Locations :call VimBoxPathsplane()
command! -nargs=0 SettingsDefaults :call <SID>VimBoxSplitSettings(PathJoinDir(g:vimBoxStockPluginsDir, 'vim-box'), 1)
command! -complete=color -nargs=? SettingsUI :call VimBoxConfigsplain(<q-args>)
command! -complete=customlist,ListConfig -nargs=1 Get :call VimBoxSettingUICommand(<q-args>)


augroup vimbox-report-load-errors
  autocmd!
  autocmd VimEnter * call <SID>VimBoxReportLoadErrors()
augroup END
