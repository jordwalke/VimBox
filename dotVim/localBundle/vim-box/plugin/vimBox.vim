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
  if !empty(g:vimBoxInfosDuringLoad)
    if len(g:vimBoxInfosDuringLoad) > 1
      let i = 0
      while i < len(g:vimBoxInfosDuringLoad)
        call console#Info(g:vimBoxInfosDuringLoad[i])
        let i = i + 1
      endwhile
      call console#Info("Multiple Info messages during load. See :Console")
    else
      if len(g:vimBoxInfosDuringLoad) == 1
        call console#Info(g:vimBoxInfosDuringLoad[0])
      else
      endif
    endif
  endif
  if !empty(g:vimBoxSuccessesDuringLoad)
    if len(g:vimBoxSuccessesDuringLoad) > 1
      let i = 0
      while i < len(g:vimBoxSuccessesDuringLoad)
        call console#Success(g:vimBoxSuccessesDuringLoad[i])
        let i = i + 1
      endwhile
      call console#Success("Multiple Success messages during load. See :Console")
    else
      if len(g:vimBoxSuccessesDuringLoad) == 1
        call console#Success(g:vimBoxSuccessesDuringLoad[0])
      else
      endif
    endif
  endif
  if !empty(g:vimBoxWarningsDuringLoad)
    if len(g:vimBoxWarningsDuringLoad) > 1
      let i = 0
      while i < len(g:vimBoxWarningsDuringLoad)
        call console#Warn(g:vimBoxWarningsDuringLoad[i])
        let i = i + 1
      endwhile
      call console#Warn("Multiple Warn messages during load. See :Console")
    else
      if len(g:vimBoxWarningsDuringLoad) == 1
        call console#Warn(g:vimBoxWarningsDuringLoad[0])
      else
      endif
    endif
  endif
  if !empty(g:vimBoxErrorsDuringLoad)
    if len(g:vimBoxErrorsDuringLoad) > 1
      let i = 0
      while i < len(g:vimBoxErrorsDuringLoad)
        call console#Error(g:vimBoxErrorsDuringLoad[i])
        let i = i + 1
      endwhile
      call console#Error("Multiple Error messages during load. See :Console")
    else
      if len(g:vimBoxErrorsDuringLoad) == 1
        call console#Error(g:vimBoxErrorsDuringLoad[0])
      else
      endif
    endif
  endif
endfunction

" Less important, more for debugging and exploring
command! -nargs=0 VimBoxRc :execute 'e ' . g:vimBoxGeneratedRc
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
command! -nargs=0 Settings :call <SID>VimBoxSplitSettings(g:vimBoxUserPluginDir, 0)
command! -nargs=0 Locations :call VimBoxPathsplane()
command! -nargs=0 SettingsDefaults :call <SID>VimBoxSplitSettings(PathJoinDir(g:vimBoxStockPluginsDir, 'vim-box'), 1)
command! -complete=color -nargs=? SettingsUI :call VimBoxConfigsplain(<q-args>)
command! -complete=customlist,ListConfig -nargs=1 Get :call VimBoxSettingUICommand(<q-args>)


augroup vimbox-report-load-errors
  autocmd!
  autocmd VimEnter * call <SID>VimBoxReportLoadErrors()
augroup END
