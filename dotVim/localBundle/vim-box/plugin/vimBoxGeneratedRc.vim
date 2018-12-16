
" For scopes,
" vim "set"s should become setlocals inside their respective filetype
" autocommands.
"
" exists("&bom")  If a setting exists (doesn't distinguish between values - just that it is supported')
"
" For yes/no settings.
" getbufvar(bufnumber, "&altkeymap")                 returns 1 for "set altkeymap" and 0 for "set noaltkeymap"
" getbufvar(bufnumber, "&backupdir")                 returns the &backupdir setting for the buffer
" getbufvar(bufnumber, "named")                      returns the b:named variable for the buffer
"
" "tabwinvar" is less useful for user config and more useful for UI based
" plugins.
" gettabwinvar(tabN, winN, "&altkeymap", default)    returns 1 for "set altkeymap" and 0 for "set noaltkeymap"
" gettabwinvar(tabN, winN, "&backupdir", default)    returns the &backupdir setting for the tabpage and windownum
" gettabwinvar(tabN, winN, "named", default)         returns the w:named setting for the tabpage and windownum
"
" The setlocal command tries to set values as local as possible for settings.
" Either buffer or window.
" setlocal setting=foo
" setlocal setting
"
" There is also getwinvar which is like gettabwinvar but for the current tab page.
" There is also a gettabvar
"
" The desired algorithm for determining a config would look something like
" this:
"
" get(varName)
"   if exists at buffer defined level
"     return the buffer defined value
"   else if it exists at the global level
"     return the global value
"   endif
"
" Ideally VimBox scoped variables become buffer local variables with
" automatically generated filetype hooks, and would also be rolled back
" if the filetype changes to something else.
"
" As with everything, we should record what the values were before we applied
" the config, and roll them back (unletting if necessary)
"
" Mappings applied in scope would be setup in the autocommand section and use
" <buffer>
" :autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
" :autocmd FileType python     nnoremap <buffer> <localleader>c I#<esc>
"
"
" For scoped settings, setlocal should be used.
"
" Difference between ftplugin and autocommand with FileType event:
" https://stackoverflow.com/questions/7863804/autocmd-filetype-vs-ftplugin?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
"
"
" Mappings Behavior:
"
" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)
" In insert mode, <C-O> allows you to map to a behavior without leaving insert
" mode. Mapping <C-\><C-O> resolves some of the incorrect behavior with that.

function! s:Comment(indent, origin, pluginName, kind, name, v)
  return [
        \ "",
        \ a:indent . '" ' . a:origin,
        \ a:indent . '" ' . a:pluginName . "." . a:kind . "." . a:name . " = " . a:v
        \]
endfunction

function! s:LogInitError(indent, origin, str)
  return [a:indent . 'call console#Error("Configuration Error In ' . escape(a:origin, '\') . ' '  . escape(a:str, '\"') . '")']
endfunction


" These are the various mapping modes of vim. They are very difficult to
" remember. So we will spell out the modes explicitly, in camelCase form.
" We won't support Lang-arg.
" When supplying mappings in your config, you have to use one of these.
" They're pretty comprehensiv though.
"
"   :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
"   :nmap  :nnoremap :nunmap    Normal
"   :vmap  :vnoremap :vunmap    Visual and Select
"   :smap  :snoremap :sunmap    Select
"   :xmap  :xnoremap :xunmap    Visual
"   :omap  :onoremap :ounmap    Operator-pending
"   :map!  :noremap! :unmap!    Insert and Command-line
"   :imap  :inoremap :iunmap    Insert
"   :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
"   :cmap  :cnoremap :cunmap    Command-line
let s:sortedMappings = {
    \ 'normal': ['nnoremap', 'nunmap'],
    \ 'select': ['snoremap', 'sunmap'],
    \ 'visual': ['xnoremap', 'xunmap'],
    \ 'insert': ['inoremap', 'iunmap'],
    \ 'commandLine': ['cnoremap', 'cunmap'],
    \ 'normal operatorPending select visual': ['noremap', 'unmap'],
    \ 'select visual': ['vnoremap', 'vunmap'],
    \ 'operatorPending': ['onoremap', 'ounmap'],
    \ 'commandLine insert': ['noremap!', 'unmap!'],
    \ 'commandLine insert languageArg': ['lnoremap', 'lunmap'],
    \ 'normalRemapped': ['nmap', 'nunmap'],
    \ 'selectRemapped': ['smap', 'sunmap'],
    \ 'visualRemapped': ['xmap', 'xunmap'],
    \ 'insertRemapped': ['imap', 'iunmap'],
    \ 'commandLineRemapped': ['cmap', 'cunmap'],
    \ 'normalRemapped operatorPendingRemapped selectRemapped visualRemapped': ['map', 'unmap'],
    \ 'selectRemapped visualRemapped': ['vmap', 'vunmap'],
    \ 'operatorPendingRemapped': ['omap', 'ounmap'],
    \ 'commandLineRemapped insertRemapped': ['map!', 'unmap!'],
    \ 'commandLineRemapped insertRemapped languageArgRemapped': ['lmap', 'lunmap']
  \ }

let s:mappedToKinds = {
    \ 'nop': 1,
    \ 'command': 1,
    \ 'keys': 1
    \}
let s:validMapAttrs = {
      \ "@buffer": 1,
      \ "@nowait": 1,
      \ "@silent": 1,
      \ "@special": 1,
      \ "@script": 1,
      \ "@expr": 1,
      \ "@unique": 1
      \ }
" The two most usable-by-default VimBox modes are !insert, and all.  Both will
" first send <Escape> to make sure you are out of the current pending
" operation or partially written command line command, before invoking the
" command. If in insert mode, 'all' will then put you back into insert mode
" restoring the cursor position. 'all' is not quite all, it doesn't handle
" languageArg, but that seems rare enough.
function! s:Mapping(indent, pluginName, kind, name, v, isScoped, origin, fakeMappingsLookup)
  let mappingFrom = split(a:name, ":")
  let mappingTo = split(a:v, ":")
  if empty(mappingTo)
    return s:LogInitError(a:indent, a:origin, 'Key mapping (value) configured incorrectly "' . a:name . '":"' . a:v. '"')
  endif
  if empty(mappingFrom)
    return s:LogInitError(a:indent, a:origin, 'Key mapping (key) configured incorrectly "' . a:name . '":"' . a:v . '"')
  endif
  if len(mappingFrom) == 1
    return s:LogInitError(a:indent, a:origin, 'Key mapping (key) configured incorrectly  "' . a:name . '":"' . a:v . '". The key must begin with a space separated list of modes that the mapping should occur in (insert, normal, all) followed by a colon')
  endif
  let modesStr = mappingFrom[0]
  let modesStr = substitute(modesStr, "all", "normal select visual insert commandLine", "g")
  let modesStr = substitute(modesStr, "!insert", "normal select visual commandLine", "g")
  let modes = split(modesStr, "\\s\\+")
  let mapModes = copy(modes)
  let mapAttrs = copy(modes)
  call filter(mapModes, 'v:val[0]!="@"')
  call filter(mapAttrs, 'v:val[0]=="@"')
  call sort(mapModes)
  let ret  = []
  let fromKey = join(mappingFrom[1:], ":")
  let mappedToKind = 'nop'
  if len(mappingTo) == 1
    if mappingTo[0] == "nop"
      let mappedToTarget = "<nop>"
      let mappedToKind = "nop"
    else
      return s:LogInitError(a:indent, a:origin, 'Key mapping (value) is configured incorrectly "' . a:name . '":"' . a:v . '". The value must be one of the forms "command:yourCommand", "keys:yourKeys", or "nop"')
    endif
  else
    " Special case of `keys::`  (mapping to the key colon)
    if len(mappingTo) == 2 && mappingTo[1] == ''
      let mappedToTarget = ":"
      let mappedToKind = mappingTo[0]
    else
      " Since we split on colon, there might be colons in the target
      let mappedToTarget = join(mappingTo[1:], ":")
      let mappedToKind = mappingTo[0]
    endif
  endif
  if !has_key(s:mappedToKinds, mappedToKind)
    call extend(ret, s:LogInitError(a:indent, a:origin, 'Invalid mapping (value) kind "' . mappedToKind . '". The right hand side of a mapping must be "kind:str" where kind is one of (keys, command,  nop)'))
  else
    " We end up just breaking out into several mappings anyways because
    " command: style mappings require it.
    for mode in mapModes
      if !has_key(s:sortedMappings, mode)
        call extend(ret, s:LogInitError(a:indent, a:origin, 'Invalid key mode "' . mode . '". use one of (all, !insert, ' . join(["commandLine" , "commandLineRemapped" , "insert" , "insertRemapped" , "languageArg" , "languageArgRemapped" , "normal" , "normalRemapped" , "operatorPending" , "operatorPendingRemapped" , "select" , "selectRemapped" , "visual" , "visualRemapped"], ", ") . ")"))
      else
        " Remove redundant <buffer> attributes which will be added
        " automatically
        if a:isScoped
          call filter(mapAttrs, 'v:val[0]=="@buffer"')
        endif
        let invalidAttrs = copy(mapAttrs)
        call filter(invalidAttrs, '!has_key(s:validMapAttrs, v:val)')
        let c = 0
        while c < len(invalidAttrs)
          call extend(ret, s:LogInitError(a:indent, a:origin, 'Invalid key mapping attribute "' . invalidAttrs[c] . '". Must be one of (' . join(keys(s:validMapAttrs), ",") . ")"))
          let c = c+1
        endwhile
        let validAttrTokens = copy(mapAttrs)
        call map(validAttrTokens, '" <" . strpart(v:val, 1) . "> "')
        if a:isScoped
          call extend(validAttrTokens, ["<buffer>"])
        endif
        let vimCommand = s:sortedMappings[mode][0] . join(validAttrTokens, "")
        let suffix = mappedToKind == 'command' ? '<Cr>' : ''
        let prefix = mode == 'insert' && mappedToKind == 'command' ? '<C-\><C-o>:' :
         \ (mappedToKind == 'command' ? '<Esc>:' : '')
        if has_key(a:fakeMappingsLookup, fromKey)
          let pressedKey = a:fakeMappingsLookup[fromKey]
          let comment = s:Comment(a:indent, a:origin, a:pluginName, a:kind, a:name, "fakeMap configuration swapped " . fromKey . " with  " . pressedKey)
          call extend(ret, comment)
          let fromKey = pressedKey
        endif
        call extend(ret, [
        \  a:indent . vimCommand . ' ' . fromKey . ' ' . prefix . mappedToTarget . suffix
        \ ])
      endif
    endfor
  endif
  return ret
endfunction

function! s:Setting(indent, pluginName, kind, name, v, isScoped, origin)
  " For info on "letting" settings.
  " http://vimdoc.sourceforge.net/htmldoc/eval.html#:let-option
  if a:pluginName == "vim"
    " Colorscheme requires special case.
    if a:name == "colorscheme"
      if type(a:v) == v:t_string
        return [a:indent . "exec \"colorscheme " . a:v . "\""]
      else
        return s:LogInitError(indent, a:origin, "Colorscheme configured incorrectly. Must be a string. Try :SettingsUI vim.config.colorscheme")
      endif
    else
      if type(a:v) == v:t_string && strpart(a:v, 0, 5) == 'eval:'
        let normalizedVal = strpart(a:v, 5)
      else
        let normalizedVal = string(a:v)
      endif
      let setPrefix = a:isScoped ? "let &l:" : "let &"
      " Leave no space around = so that you can name a variable 'setting+' to
      " have it render as: let &setting+=foo
      return [a:indent . setPrefix . a:name . "=" . normalizedVal]
    endif
  else
    if a:pluginName == "installer"
      return s:Install(a:indent, a:pluginName, a:kind, a:isScoped, a:name, a:v)
    else
      if type(a:v) == v:t_string && strpart(a:v, 0, 5) == 'eval:'
        let normalizedVal = strpart(a:v, 5)
      else
        let normalizedVal = string(a:v)
      endif
      if len(a:name) > 1 && (a:name[1] == ":" || a:name[0] == "$")
        return [a:indent . "let " . a:name . " = " . normalizedVal]
      else
        let joiner = a:name[0] == "#" ? "" : "_"
        let setPrefix = a:isScoped ? "let b:" . a:pluginName . joiner : "let g:" . a:pluginName . joiner
        return [a:indent . setPrefix . a:name . " = " . normalizedVal]
      endif
    endif
    endif
  endif
endfunction

" Gates installation of a plugin based on if that plugin has been disabled
function! s:InstallDisablerCheck(name, lines)
  let ifCheck = ["if !exists('g:disabler_" . a:name . "') || !g:disabler_" . a:name]
  call extend(ifCheck, a:lines )
  call extend(ifCheck, ["endif"])
  return ifCheck
endfunction

" Gates configuration of a plugin based on if that plugin has been disabled
function! s:ConfigDisablerReturn(name)
  return [
        \ "if exists('g:disabler_" . a:name . "') && g:disabler_" . a:name,
        \ "  return",
        \ "endif"
        \ ]
endfunction

function! s:Install(indent, pluginName, kind, isScoped, name, v)
  let installData = __VimBoxGetPluginInstallData(a:v)
  if a:isScoped
    return s:LogInitError(a:indent, "Unknown Origin", "Some plugin configured " . a:pluginName . " to be installed in a language scope config. All 'install' fields should be under the '*' scope and in your personal config.")
  endif
  let domain = installData['domain']
  let repoName = installData['repoName']
  let branch = installData['branch']
  if !empty(domain)
    if domain == 'fileSystem'
      " In this case the repoName is the path
      return s:InstallDisablerCheck(a:name, ["  Plug '" . repoName . "'"])
    else
      let userRepo = domain . '/' . repoName
      if !empty(branch)
        return s:InstallDisablerCheck(a:name, ["  Plug '" . userRepo . "', {'branch': '" . branch . "'}"])
      else
        return s:InstallDisablerCheck(a:name, ["  Plug '" . userRepo . "'"])
      endif
    endif
  else
    let repoName = repoName
    if a:pluginName == 'vim' || a:pluginName == 'vimBox' || a:pluginName == 'session'
    else
      return s:InstallDisablerCheck(a:name, ["  Plug '" . repoName . "'"])
    endif
  endif
endfunction


" It's much faster to generate this once for all lookups.
function! s:VimBoxGenerateFakeMappingsLookup(resolvedConfigForScope)
  let lookup = {}
  if has_key(a:resolvedConfigForScope, 'fakeMap') && has_key(a:resolvedConfigForScope['fakeMap'], 'mappings')
    let fakeMapMappings = a:resolvedConfigForScope['fakeMap']['mappings']
    for pressedKey in Keys(fakeMapMappings)
      let entries = a:resolvedConfigForScope['fakeMap']['mappings'][pressedKey]
      let entry = entries[len(entries) - 1]
      let hasSimulatedKey = VimBoxHasValueFromResolvedConfigEntry(entry)
      if hasSimulatedKey
        let simulatedKey = VimBoxGetValueFromResolvedConfigEntry(entry)
        let lookup[simulatedKey] = pressedKey
      endif
    endfor
  endif
  return lookup
endfunction

function! s:VimBoxGenerateVimRcForPlugin(lines, pluginName, resolvedConfigForScope, isScoped)
  call extend(a:lines, s:ConfigDisablerReturn(a:pluginName))
  let pluginName = a:pluginName
  let indent = a:isScoped ? "  " : ""

  let fakeMappingsLookup = s:VimBoxGenerateFakeMappingsLookup(a:resolvedConfigForScope)
  for kind in Keys(a:resolvedConfigForScope[pluginName])
    for name in Keys(a:resolvedConfigForScope[pluginName][kind])
      let entries = a:resolvedConfigForScope[pluginName][kind][name]
      if !empty(entries)
        let entry = entries[len(entries) - 1]
        let hasValue = VimBoxHasValueFromResolvedConfigEntry(entry)
        if name =~ ":description$" || name =~ ":possibleValues$"
        else
          let origin = entry['origin']
          if hasValue
            let value = VimBoxGetValueFromResolvedConfigEntry(entry)
            let comment = s:Comment(indent, origin, pluginName, kind, name, VimBoxValuePrint(value))
            if kind == "config"
              let line = s:Setting(indent, pluginName, kind, name, value, a:isScoped, origin)
            else
              if kind == "actions"
                let line = []
              else
                " We don't actually process fakeMap mappings.
                if kind == "mappings"
                  if pluginName == "fakeMap"
                    let line = ["\" Not generaing fakeMap mapping. It's fake."]
                  else
                    let line = s:Mapping(indent, pluginName, kind, name, value, a:isScoped, origin, fakeMappingsLookup)
                  endif
                endif
              endif
            endif
            call extend(a:lines, comment)
            call extend(a:lines, line)
          else
            let comment = s:Comment(indent, origin, pluginName, kind, name, "<not configured>")
            call extend(a:lines, comment)
          endif
        endif
      endif
    endfor
  endfor
endfunction

function! s:VimBoxGenerateVimRc(lines, resolvedConfigForScope, scopeSuffix)
  let isScoped = a:scopeSuffix != ""
  let indent = isScoped ? "  " : ""
  " Make sure to explicitly call
  " __VimBoxGeneratedConfigure_disabler_ForScope_() before calling
  " __VimBoxGeneratedPlugCalls in the bootstrapping code. The disabler
  " function would end up being called twice but that's not a big deal. It's
  " idempotent.
  " Install is not scope based.
  if has_key(a:resolvedConfigForScope, "installer")
    call extend(a:lines, ['', '', indent . '" ====================================================', indent . '" Installed Plugins:', indent . '" ===================================================='])
    call extend(a:lines, [indent . "function! __VimBoxGeneratedPlugCalls()"])
    call s:VimBoxGenerateVimRcForPlugin(a:lines, "installer", a:resolvedConfigForScope, isScoped)
    call extend(a:lines, [indent . "endfunction"])
  endif
  let pluginFunctionNames = []
  for pluginName in Keys(a:resolvedConfigForScope)
    if pluginName != "installer"
      call extend(a:lines, ['', '', indent . '" ====================================================', indent . '" Configure Plugin: ' . pluginName, indent . '" ===================================================='])
      let pluginFunctionName = "__VimBoxGeneratedConfigure_" . pluginName . "_ForScope_" . a:scopeSuffix
      call extend(pluginFunctionNames, [pluginFunctionName])
      call extend(a:lines, [indent . "function! " . pluginFunctionName . "()"])
      call s:VimBoxGenerateVimRcForPlugin(a:lines, pluginName, a:resolvedConfigForScope, isScoped)
      call extend(a:lines, [indent . "endfunction"])
    endif
  endfor
  call extend(a:lines, ['', '', indent . '" ====================================================', indent . '" Configure All: ', indent . '" ===================================================='])
  call extend(a:lines, ["", indent . "function! __VimBoxGeneratedConfigureForScope_" . a:scopeSuffix . "()"])
  for pluginFunctionName in pluginFunctionNames
    call extend(a:lines, [indent . "  call " . pluginFunctionName . "()"])
  endfor
  call extend(a:lines, [indent . "endfunction"])
endfunction

function! VimBoxGenerateVimRc()
  " Now we go and convert it back to a form more similar to the original!
  " But it is the resolved config, not original json.
  let resolvedConfigByScope = VimBoxResolvedConfigByScope(g:vimBox__resolvedConfig)

  let lines = [
        \ '" ================================================',
        \ '"         .__           ___.',
        \ '"  ___  __|__|  _____   \_ |__    ____  ___  ___',
        \ '"  \  \/ /|  | /     \   | __ \  /  _ \ \  \/  /',
        \ '"   \   / |  ||  Y Y  \  | \_\ \(  <_> ) >    <',
        \ '"    \_/  |__||__|_|  /  |___  / \____/ /__/\_ \',
        \ '"                   \/       \/               \/',
        \ '" ================================================',
        \ '',
        \ '',
        \ '" ----------------------------------',
        \ '" Configuration for all file types *',
        \ '" ----------------------------------']
  call s:VimBoxGenerateVimRc(lines, resolvedConfigByScope['*'], "")
  for scopeName in Keys(resolvedConfigByScope)
    if scopeName != '*'
      call extend(lines, ["", "", '" ------------------------------------', '" Configuration for file type ' . scopeName, '" ------------------------------------' ])
      call extend(lines, ["function! s:VimBoxFileType_" . scopeName . "()"])
      call s:VimBoxGenerateVimRc(lines, resolvedConfigByScope[scopeName], scopeName)
      call extend(lines, ["  call __VimBoxGeneratedConfigureForScope_" . scopeName . "()", ""])
      call extend(lines, ["endfunction", ""])
      call extend(lines, ["augroup VimBox_" . scopeName])
      call extend(lines, ["  autocmd!"])
      call extend(lines, ["  autocmd Filetype " . scopeName . " call s:VimBoxFileType_" . scopeName . "()"])
      call extend(lines, ["augroup END"])
    endif
  endfor
  call writefile(lines, g:vimBoxGeneratedRc)
endfunction

