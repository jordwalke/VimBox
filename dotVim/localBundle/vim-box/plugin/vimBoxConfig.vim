" The way ConfigChanged will be called is as follows:
" Calls to `:SetConfig 'pluginName.foo.bar' value` will modify the
" `user/settings.json` file.
" Then all the precedences are applied until an actual change is discovered.
" Then the plugins responsible for those configs changing get their
" `ConfigChanged` called. In turn, those subscribers may also set other
" config for other plugins. The whole precedence process is re-ran, and then
" *if* a config change is actually detected, then the responsible plugins are
" notified - and so on and so on (but at most n times).
function! ConfigChanged(config)
  SetConfig('vimDevIcons', 'g:webdevicons_enable', config['ui']['useDevIcons'])
endfunction

if !exists('g:vimBox__trackedConfigs')
  let g:vimBox__trackedConfigs = {}
endif
if !exists('g:vimBox__trackedPackageJsons')
  let g:vimBox__trackedPackageJsons = {}
endif
if !exists('g:vimBox__trackedConfigPriorities')
  let g:vimBox__trackedConfigPriorities = {}
endif
if !exists('g:vimBox__resolvedConfig')
  let g:vimBox__resolvedConfig = {}
endif
if !exists('g:vimBox__searchIndex')
  let g:vimBox__searchIndex = {'config':{}, 'mappings':{}, 'actions': {}}
endif

function! Keys(obj)
  return type(a:obj) == v:t_dict ? keys(a:obj) : []
endfunction


function! VimBoxSearchSettingsFiles()
  return [
      \ 'settings.json',
      \ 'settings.' . g:vimBoxOs . '.json',
      \ 'settings.' . g:vimBoxGui . '.json',
      \ 'settings.' . g:vimBoxGui . '.' . g:vimBoxOs . '.json',
      \ 'settings.' . g:vimBoxOs . '.' . g:vimBoxGui . '.json',
      \ ]
endfunction


" Copies example settings files for current platform/ui when none exist.
" TODO: Move all the directory initialization here, not just copying of
" example configs.
function! VimBoxPopulateDefaultConfigs(defaultDir, userConfigDir)
  let files = []
  for filename in VimBoxSearchSettingsFiles()
    let userConfigPath = PathJoinFile(a:userConfigDir, filename)
    if !file_readable(userConfigPath)
      let defaultConfigPath = PathJoinFile(a:defaultDir, filename)
      if file_readable(defaultConfigPath)
        call writefile(readfile(defaultConfigPath), userConfigPath)
      endif
    endif
  endfor
endfunction

" We will skip over the "user plugin" because we always want it to have the
" highest priority so will be processed last.
" Searches for these files at the root of every runtime path root (in
" increasing priority).
"
"   settings.json
"   settings.gui.json
"   settings.osx.json
"   settings.osx.gui.json
"   settings.gui.json
"   settings.osx.term.json
"
" (Or linux/windows instead of osx if on those platforms)
function! VimBoxInitConfigs()
  " Call "unregister" on any already registered plugin.
  let g:vimBox__trackedConfigs = {}
  let g:vimBox__trackedPackageJsons = {}
  let rtps = split(&rtp, ",")
  let rtpsLen = len(rtps)
  " Add one to make room for user config added to end
  let g:vimBox__trackedConfigPriorities = []
  for rootPath in rtps
    for fileName in VimBoxSearchSettingsFiles()
      let configPath = PathJoinFile(rootPath, fileName)
      if !(rootPath == g:vimBoxUserPluginDir) && file_readable(expand(configPath))
        let data = {}
        try
          let data = json_ponyfill#json_decode(join(readfile(configPath)))
        catch
          call VimBoxUserMessageError("Config file " . configPath . " has a syntax error.")
        endtry
        let g:vimBox__trackedConfigs[configPath] = {'pluginRootDir': configPath, 'data': data}
        call add(g:vimBox__trackedConfigPriorities, configPath)
      endif
      let packageJsonPath = PathJoinFile(rootPath, 'package.json')
      if !(rootPath == g:vimBoxUserPluginDir) && file_readable(expand(packageJsonPath))
        let g:vimBox__trackedConfigs[configPath] = {'pluginRootDir': rootPath, 'data': json_ponyfill#json_decode(join(readfile(packageJsonPath)))}
        call add(g:vimBox__trackedConfigPriorities, configPath)
      endif
    endfor
  endfor
  for fileName in VimBoxSearchSettingsFiles()
    let vimBoxUserConfigJsonPath = PathJoinFile(g:vimBoxUserPluginDir, fileName)
    let vimBoxUserConfigJsonData = {}
    if file_readable(expand(vimBoxUserConfigJsonPath))
      let fileContents = join(readfile(vimBoxUserConfigJsonPath))
      let vimBoxUserConfigJsonData = {}
      try
        let vimBoxUserConfigJsonData = json_ponyfill#json_decode(fileContents)
      catch
        call VimBoxUserMessageError("Config file " . vimBoxUserConfigJsonPath . " has a syntax error.")
      endtry
    endif
    let g:vimBox__trackedConfigs[vimBoxUserConfigJsonPath] = {'pluginRootDir': g:vimBoxUserPluginDir, 'data': vimBoxUserConfigJsonData}
    call add(g:vimBox__trackedConfigPriorities, vimBoxUserConfigJsonPath)
  endfor
  call VimBoxResolveConfigs()
endfunction


function! VimBoxNotifyAndSetNextResolvedConfig(nextSearchIndex, nextResolvedConfig)
  let g:vimBox__resolvedConfig = a:nextResolvedConfig
  let g:vimBox__searchIndex = a:nextSearchIndex
endfun

function! __VimBoxGetPluginInstallData(s)
  if(empty(a:s))
    return {}
  endif
  if strpart(a:s, 0, 5) == 'file:'
    let fileSpec = strpart(a:s, 5)
    " See :help sub-replace-special. Backslashes have special meaning in the
    " substituted string and there's no way to just have substitute() treat
    " the string as a regular string! Double backslash means single backslash
    " in the substituted string so we need to first turn every backslash in
    " the substitute string into double backslashes.
    let installRoot = substitute(g:vimBoxInstallationRoot, "\\", "\\\\\\\\", "g")
    let userPluginDir = substitute(g:vimBoxUserPluginDir, "\\", "\\\\\\\\", "g")
    let xdgConfigDir = substitute(g:vimBoxXdgConfigDir, "\\", "\\\\\\\\", "g")
    let stockPluginsDir = substitute(g:vimBoxStockPluginsDir, "\\", "\\\\\\\\", "g")

    let fileSpec = substitute(fileSpec, "$vimBoxInstallationRoot/", installRoot, "g")
    " In case they entered it with a backslash:
    let fileSpec = substitute(fileSpec, "$vimBoxInstallationRoot\\", installRoot, "g")
    " or heck, even with no slash (imagine just setting the whole config val
    " to "file:$vimBoxInstallationRoot")
    let fileSpec = substitute(fileSpec, "$vimBoxInstallationRoot", installRoot, "g")

    let fileSpec = substitute(fileSpec, "$vimBoxUserPluginDir/", userPluginDir, "g")
    " In case they entered it with a backslash:
    let fileSpec = substitute(fileSpec, "$vimBoxUserPluginDir\\", userPluginDir, "g")
    " or heck, even with no slash (imagine just setting the whole config val
    " to "file:$vimBoxUserPluginDir")
    let fileSpec = substitute(fileSpec, "$vimBoxUserPluginDir", userPluginDir, "g")

    let fileSpec = substitute(fileSpec, "$vimBoxXdgConfigDir/", xdgConfigDir, "g")
    " In case they entered it with a backslash:
    let fileSpec = substitute(fileSpec, "$vimBoxXdgConfigDir\\", xdgConfigDir, "g")
    " or heck, even with no slash (imagine just setting the whole config val
    " to "file:$vimBoxXdgConfigDir")
    let fileSpec = substitute(fileSpec, "$vimBoxXdgConfigDir", xdgConfigDir, "g")

    let fileSpec = substitute(fileSpec, "$vimBoxStockPluginsDir/", stockPluginsDir, "g")
    " In case they entered it with a backslash:
    let fileSpec = substitute(fileSpec, "$vimBoxStockPluginsDir\\", stockPluginsDir, "g")
    " or heck, even with no slash (imagine just setting the whole config val
    " to "file:$vimBoxStockPluginsDir")
    let fileSpec = substitute(fileSpec, "$vimBoxStockPluginsDir", stockPluginsDir, "g")

    let dir = (fileSpec)
    return {'repoName': dir, 'domain': 'fileSystem', 'branch': ''}
  else
    let splitOnSlash = split(a:s, '/')
    if len(splitOnSlash) > 1
      let domain = splitOnSlash[0]
      let rest = split(splitOnSlash[1], '#')
      if len(rest) > 1
        let repoName = rest[0]
        let branch = rest[1]
        return {'repoName': repoName, 'domain': domain, 'branch': branch}
      else
        let repoName = rest[0]
        return {'repoName': repoName, 'domain': domain, 'branch': ''}
      endif
    else
      return {'repoName': a:s, 'domain': domain, 'branch': ''}
    endif
  endif
endfunction

function! __VimBoxIsConfigComment(ss)
  return a:ss ==? "note" || a:ss ==? "notes" || a:ss ==? "comment" || a:ss ==? "comments" || a:ss ==? "config-comment" || a:ss ==? "configcomment" || a:ss ==? "configcomments"|| a:ss ==? "config-comments"
endfunction

" Also builds up a "searchIndex" which is used as a convenient keyword search.
" Reorganizes the configuration to be different from the json form.
" The resolvedConfig is stored in a form different than it is configured
" in json. In json, it's natural to organize by scope, but when searching,
" it's natural to organize by `pluginName.kind.name` so that you can search
" and display configs, and only filtering by filetype/scope at the last
" moment.
function! VimBoxAppendToNextResolvedConfig(searchIndex, resolvedConfig, nextConfig, nextConfigPath)
  for scope in keys(a:nextConfig)
    let nextScope = a:nextConfig[scope]
    if type(nextScope) != v:t_dict
      if !__VimBoxIsConfigComment(scope)
        call VimBoxUserMessageError("Problem in config file " . a:nextConfigPath . ". Scope " . scope . " should be a dictionary with short plugin names as keys and {mappings, config, actions} as values.")
      endif
      continue
    endif
    for pluginName in Keys(nextScope)
      if !empty(nextScope[pluginName])
        if type(nextScope[pluginName]) != v:t_dict
          if !__VimBoxIsConfigComment(pluginName)
            call VimBoxUserMessageError("Problem in config file " . a:nextConfigPath . ". Config for plugin '" . pluginName . "' in scope '" . scope . "' should be a dictionary of the form {mappings, config, actions}.")
          endif
          continue
        endif
        if !has_key(a:resolvedConfig, pluginName) || empty(a:resolvedConfig[pluginName])
          let a:resolvedConfig[pluginName] = {'actions': {}, 'config': {}, 'mappings': {}}
        endif
        let resolvedPlugin = a:resolvedConfig[pluginName]
        let nextScopePlugin = nextScope[pluginName]
        for fieldName in keys(nextScopePlugin)
          if fieldName != 'config' && fieldName != 'mappings' && fieldName != 'actions'
            if !__VimBoxIsConfigComment(fieldName)
              call VimBoxUserMessageError("Problem in config file " . a:nextConfigPath . ". Config for plugin '" . pluginName . "' in scope '" . scope . "' contains an invalid key '" . fieldName . "'. It should be one of 'mappings', c)onfig, or 'actions' (or alternatively you can use the key 'notes' which can be used to write freeform notes that are ignored.)")
            endif
          endif
        endfor
        let nextScopePluginActions = (!has_key(nextScopePlugin, 'actions') || empty(nextScopePlugin['actions'])) ? {} : nextScopePlugin['actions']
        let nextScopePluginSettings = (!has_key(nextScopePlugin, 'config') || empty(nextScopePlugin['config'])) ? {} : nextScopePlugin['config']
        let nextScopePluginMappings = (!has_key(nextScopePlugin, 'mappings') || empty(nextScopePlugin['mappings'])) ? {} : nextScopePlugin['mappings']
        let resolvedPluginActions = resolvedPlugin['actions']
        let resolvedPluginSettings = resolvedPlugin['config']
        let resolvedPluginMappings = resolvedPlugin['mappings']
        for actionName in keys(nextScopePluginActions)
          if !has_key(resolvedPluginActions, actionName)
            let resolvedPluginActions[actionName] = {}
          endif
          if !has_key(resolvedPluginActions[actionName], scope)
            let resolvedPluginActions[actionName][scope] = []
          endif
          call add(resolvedPluginActions[actionName][scope], {'origin': a:nextConfigPath, 'config': nextScopePluginActions[actionName] })
          let indexKey = pluginName . '.actions.' . actionName
          let a:searchIndex['actions'][indexKey] = 1
        endfor
        for settingName in keys(nextScopePluginSettings)
          if !has_key(resolvedPluginSettings, settingName)
            let resolvedPluginSettings[settingName] = {}
          endif
          if !has_key(resolvedPluginSettings[settingName], scope)
            let resolvedPluginSettings[settingName][scope] = []
          endif
          call add(resolvedPluginSettings[settingName][scope], {'origin': a:nextConfigPath, 'config': nextScopePluginSettings[settingName] })
          let indexKey = pluginName . '.config.' . settingName
          let a:searchIndex['config'][indexKey] = 1
        endfor
        for mappingName in keys(nextScopePluginMappings)
          if !has_key(resolvedPluginMappings, mappingName)
            let resolvedPluginMappings[mappingName] = {}
          endif
          if !has_key(resolvedPluginMappings[mappingName], scope)
            let resolvedPluginMappings[mappingName][scope] = []
          endif
          call add(resolvedPluginMappings[mappingName][scope], {'origin': a:nextConfigPath, 'config': nextScopePluginMappings[mappingName] })
          let indexKey = pluginName . '.mappings.' . mappingName
          let a:searchIndex['mappings'][indexKey] = {}
        endfor
      endif
    endfor
  endfor
endfunction

function! VimBoxResolveConfigs()
  let nextResolvedConfig = {}
  let nextSearchIndex = {'config':{}, 'mappings':{}, 'actions': {}}
  let i = 0
  while i < len(g:vimBox__trackedConfigPriorities)
    let configPath = g:vimBox__trackedConfigPriorities[i]
    if !empty(configPath)
      let nextConfig = g:vimBox__trackedConfigs[configPath]['data']
      let nextRootDir = g:vimBox__trackedConfigs[configPath]['pluginRootDir']
      call VimBoxAppendToNextResolvedConfig(nextSearchIndex, nextResolvedConfig, nextConfig, configPath)
    endif
    let i = i + 1
  endwhile
  call VimBoxNotifyAndSetNextResolvedConfig(nextSearchIndex, nextResolvedConfig)
endfunction

function! VimBoxGetConfigChainsByScope(pluginName, kind, name)
  let resolved = g:vimBox__resolvedConfig
  if !has_key(resolved, a:pluginName) || empty(resolved[a:pluginName])
    return {}
  else
    if !has_key(resolved[a:pluginName], a:kind) || empty(resolved[a:pluginName][a:kind])
      return {}
    else
      if !has_key(resolved[a:pluginName][a:kind], a:name) || empty(resolved[a:pluginName][a:kind][a:name])
        return {}
      else
        return resolved[a:pluginName][a:kind][a:name]
      endif
    endif
  endif
endfunction

function! VimBoxGetConfigChains(keyPath)
  let chain = split(a:keyPath, "\\.")
  if len(chain) != 3
    call VimBoxUserMessageError("Called GetConfig with invalid key path " . a:keyPath . " - Must be pluginName.field.configName")
    return {}
  endif
  let byScope = VimBoxGetConfigChainsByScope(chain[0], chain[1], chain[2])
  return byScope
endfunction

" Used for display, don't rely on at runtime for behavior
function! VimBoxValuePrint(v)
  let typ = type(a:v)
  if typ == v:t_string
    return "'" . a:v . "'"
  endif
  if typ == v:t_list
    return string(a:v)
  endif
  if typ == v:t_dict
    return string(a:v)
  endif
  " TODO: This confuses zero for null. Must examine types.
  " The ponyfill will have nulls mapped to zero.
  if a:v == v:null
    return "null"
  else
    if a:v == v:true
      return "true"
    else
      if a:v == v:false
        return "false"
      else
        return string(a:v)
      endif
    endif
  endif
endfunction

function! VimBoxDisplayUiInSplit(lines, tmpFilePath)
  let freshVim = VimBoxIsStartScreen()
  execute ":vsplit " . a:tmpFilePath
  if freshVim
    execute "wincmd p"
    execute "hide"
  endif
  execute " set noreadonly"
  execute " setlocal buftype="
  " Clear any contents that might have been there.
  execute "1,$d|"
  call append(0, a:lines)
  execute " set readonly"
  execute " setlocal buftype=nowrite"
  execute " set filetype=settings"
  execute " setlocal bufhidden=hide"
  " execute " setlocal nobuflisted"
  execute " setlocal foldcolumn=0"
  execute " setlocal nofoldenable"
  execute " setlocal nonumber"
  execute " setlocal noswapfile"
  execute " set nowrap"
  execute " set linebreak"
  execute " set breakindent"
  execute " set conceallevel=2"
  execute " set concealcursor=nvi"
  execute " normal! gg"
endfunction

" Gets the user configured value from the 'config' entry in the resolved
" config. Doesn't validate the value but indicates that it does/doesn't exist.
" TODO: nulls come across as 0 in the json polyfill.
" Make sure everyone checks "has value" first, and then check that nothing
" relies on null being distinct from zero.
" That way VimBox will work with older vims.
function! VimBoxGetValueFromResolvedConfigEntry(obj)
  return a:obj['config']
endfunction

function! VimBoxHasValueFromResolvedConfigEntry(obj)
  if type(a:obj) == v:t_dict && has_key(a:obj, 'config')
    return 1
  else
    return 0
  endif
endfunction

function! VimBoxSettingUICommand(keyPath)
  let byScope = VimBoxGetConfigChains(a:keyPath)
  let curFiletype = &filetype
  let resolvedEntry = 0
  if has_key(byScope, curFiletype)
    if !empty(byScope[curFiletype])
      let resolvedEntry = byScope[curFiletype][len(byScope[curFiletype]) - 1]
    endif
  endif
  if has_key(byScope, '*')
    if !empty(byScope['*'])
      let resolvedEntry = byScope['*'][len(byScope['*']) - 1]
    endif
  endif
  if VimBoxHasValueFromResolvedConfigEntry(resolvedEntry)
    let gottenValue = VimBoxGetValueFromResolvedConfigEntry(resolvedEntry)
    call VimBoxUserMessage(VimBoxValuePrint(gottenValue))
  else
    call VimBoxUserMessage("Not configured for this file type")
  endif
endfunction


function! VimBoxExplainAll()
  let vimBoxMarkdownResult = []
  for pluginName in keys(g:vimBox__resolvedConfig)
    if type(g:vimBox__resolvedConfig[pluginName]) == v:t_dict && !empty(g:vimBox__resolvedConfig[pluginName])
      call extend(vimBoxMarkdownResult, [_VimBoxPluginNameLine(pluginName, "0.0.2")])
      call extend(vimBoxMarkdownResult, _VimBoxHeading(pluginName, "0.0.2", "Description of package here", "Update", "Enabled"))
      for kind in keys(g:vimBox__resolvedConfig[pluginName])
        if type(g:vimBox__resolvedConfig[pluginName][kind]) == v:t_dict && !empty(g:vimBox__resolvedConfig[pluginName][kind])
          call extend(vimBoxMarkdownResult, [_VimBoxSubheading(kind)])
          for name in keys(g:vimBox__resolvedConfig[pluginName][kind])
            if name =~ ":description$" || name =~ ":possibleValues$"
            else
              if type(g:vimBox__resolvedConfig[pluginName][kind][name]) == v:t_dict
                call extend(vimBoxMarkdownResult, _VimBoxExplainMarkdown(pluginName . '.' . kind . '.' . name))
              endif
            endif
          endfor
          call extend(vimBoxMarkdownResult, [""])
        endif
      endfor
    endif
  endfor

  call VimBoxDisplayUiInSplit(vimBoxMarkdownResult, PathJoinFile(g:vimBoxXdgCacheDir, "settings-ui.settings"))
endfunction

" Gives an organization convenient for generating a vimrc.  Actually flips the
" mapping back to filetype based (but after all the resolved has occured.)
function! VimBoxResolvedConfigByScope(resolvedConfig)
  let byScope = {}
  for pluginName in Keys(a:resolvedConfig)
    for kind in Keys(a:resolvedConfig[pluginName])
      for name in Keys(a:resolvedConfig[pluginName][kind])
        for scopeName in Keys(a:resolvedConfig[pluginName][kind][name])
          if !has_key(byScope, scopeName)
            let byScope[scopeName] = {}
          endif
          if !has_key(byScope[scopeName], pluginName)
            let byScope[scopeName][pluginName] = {}
          endif
          if !has_key(byScope[scopeName][pluginName], kind)
            let byScope[scopeName][pluginName][kind] = {}
          endif
          let val = a:resolvedConfig[pluginName][kind][name][scopeName]
          let byScope[scopeName][pluginName][kind][name] = a:resolvedConfig[pluginName][kind][name][scopeName]
        endfor
      endfor
    endfor
  endfor
  return byScope
endfunction

function! VimBoxConfigsplain(keyPath)
  if empty(a:keyPath)
    call VimBoxExplainAll()
  else
    let chain = split(a:keyPath, "\\.")
    if len(chain) != 3
      call VimBoxUserMessageError("SettingsUI may only be passed one of (pluginName.actions.name, pluginName.config.name, pluginName.mappings.name)")
      return
    endif
    let mdLines = _VimBoxExplainMarkdown(a:keyPath)
    call VimBoxDisplayUiInSplit(mdLines, PathJoinFile(g:vimBoxXdgCacheDir, "settings-ui.settings"))
  endif
endfunction

function! VimBoxNiceDir(d)
  return substitute(a:d, g:vimBoxHomeDir, "~/", "g")
endfunction
function! VimBoxPathsplane()
  let mdLines = [
  \ "",
  \ "                          VimBox Locations                                      ",
  \ "",
  \ " VimBox is configured to read from and write to the following locations",
  \ "",
  \ ">Useful Shortcuts:",
  \ ">:Settings    (open all your personal json settings files)",
  \ ">:Rc          (open/debug the vimrc file VimBox generated from your json config)",
  \ "",
  \ " User Config  Your personal, sharable config                                    ",
  \ "",
  \ ":  " . VimBoxNiceDir(g:vimBoxXdgConfigDir),
  \ ":  └─ user/",
  \ ":     ├─ init.vim",
  \ ":     └─ settings.json",
  \ "",
  \ "g:vimBoxXdgConfigDir = " . VimBoxNiceDir(g:vimBoxXdgConfigDir),
  \ "> Main user config directory. Share this entire directory with people",
  \ "g:vimBoxUserSettings = " . VimBoxNiceDir(g:vimBoxUserSettings),
  \ "> Your personal settings.json file. Run :Settings command to open.",
  \ "g:vimBoxUserInit = " . VimBoxNiceDir(g:vimBoxUserInit),
  \ "> Your personal 'vimrc' when using VimBox. Ran after VimBox intiializes plugins.",
  \ "g:vimBoxUserPluginDir = " . VimBoxNiceDir(g:vimBoxUserPluginDir),
  \ "> The 'user plugin' (Your user config is an ordinary Vim plugin).",
  \ "",
  \ " VimBox Installation  VimBox's stock plugins and support                        ",
  \ "",
  \ ":  " . VimBoxNiceDir(g:vimBoxInstallationRoot),
  \ ":  ├─ dotVimRc                 # VimBox vimrc entrypoint.",
  \ ":  └─ dotVim/",
  \ ":     └─ localBundle/          # Stock VimBox plugins",
  \ ":        ├─ vim-box/           # The VimBox plugin, includes utilities",
  \ ":        │  └─ ⋯",
  \ ":        ├─ vim-taste/         # Other plugins",
  \ ":        ⋯",
  \ "",
  \ "g:vimBoxInstallationRoot = " . VimBoxNiceDir(g:vimBoxInstallationRoot),
  \ "> Installation root of VimBox. Contains fixed (not customizable) vimrc used",
  \ "> to bootstrap VimBox (dotVimRc). That dotVimRc:",
  \ "> - Autogenerates a vimrc (see g:vimBoxGeneratedRc) based on your json config",
  \ "> - Sources that autogenerated vimrc",
  \ "> - Then loads (as a plugin) your user config directory: " . VimBoxNiceDir(g:vimBoxUserInit),
  \ "g:vimBoxStockPluginsDir = " . VimBoxNiceDir(g:vimBoxStockPluginsDir),
  \ "> The vim-box stock plugin includes useful plugins that your personal settings.json",
  \ "> should enable.",
  \ "",
  \ " Cache Data  Location for VimBox/plugin cache files                             ",
  \ "",
  \ ":  " . VimBoxNiceDir(g:vimBoxXdgCacheDir),
  \ ":  └─ .generated.vimrc",
  \ "",
  \ "g:vimBoxXdgCacheDir = " . VimBoxNiceDir(g:vimBoxXdgCacheDir),
  \ "> Files created by VimBox for optimizing load time or storing temporary files",
  \ "g:vimBoxGeneratedRc = " . VimBoxNiceDir(g:vimBoxGeneratedRc),
  \ "> Most recently autogenerated vimrc file (created by VimBox from all json config",
  \ "> Can be opened via the :VimBoxRc command.",
  \ "",
  \ " User Data  Your personal saved data                                            ",
  \ "",
  \ " > Note: This is where you should store data you don't want shared with others",
  \ "",
  \ ":  " . VimBoxNiceDir(g:vimBoxXdgDataDir),
  \ ":  ├─ undo/",
  \ ":  ├─ vim_sessions/",
  \ ":  ├─ logs/",
  \ ":  └─ bundle/",
  \ "",
  \ "g:vimBoxXdgDataDir = " . VimBoxNiceDir(g:vimBoxXdgDataDir),
  \ "> Your personal editor data, not for sharing with others.",
  \ "g:vimBoxUndoDir = " . VimBoxNiceDir(g:vimBoxUndoDir),
  \ "> Undo files. Allows resuming undo history after restart.",
  \ "g:vimBoxSessionDir = " . VimBoxNiceDir(g:vimBoxSessionDir),
  \ "> Session information",
  \ "g:vimBoxLogsDir = " . VimBoxNiceDir(g:vimBoxLogsDir),
  \ "> Logs from editing sessions. Run :Logs command",
  \ "g:vimBoxPluginInstallDir = " . VimBoxNiceDir(g:vimBoxPluginInstallDir),
  \ "> Plugins from personal settings.json 'installer' portion get intalled here",
  \ ""
  \]
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
  call VimBoxDisplayUiInSplit(mdLines, PathJoinFile(g:vimBoxXdgCacheDir, "settings-locations.settings"))
endfunction
