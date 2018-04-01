" Functions begin with underscore so they don't show up in autocomplete

function! _VimBoxCenterInBox(txt)
  let txt = strcharpart(a:txt, 0, 78)
  " 78 to account for the ends
  let leadSpace = repeat(" ", (78 - strchars(txt))/2)
  let remainSpace = repeat(" ", 78 - strchars(leadSpace) - strchars(txt))
  return leadSpace . txt . remainSpace
endfunction
function! _VimBoxAlignRight(txt)
  let txt = strcharpart(a:txt, 0, 78)
  " 78 to account for the ends
  let leadSpace = repeat(" ", (78 - strchars(txt)))
  return leadSpace . txt
endfunction
function! _VimBoxAlignLeft(txt)
  let txt = strcharpart(a:txt, 0, 78)
  let trailSpace = repeat(" ", (78 - strchars(txt)))
  return txt . trailSpace
endfunction

" Not for use in a box.
function! _VimBoxLeftRight(l, r)
  let l = strcharpart(a:l, 0, 80)
  let r = strcharpart(a:r, 0, 80 - strchars(l))
  let midSpace = repeat(" ", (80 - strchars(l) - strchars(r)))
  return l . midSpace . r
endfunction
function! _VimBoxHeading(name, versionNum, description, update, status)
  let source = ''
  let repoName = a:name
  if a:name == 'vim' || a:name == 'vimBox' || a:name == 'session'
    let source = 'Built In Package:'
  else
    if empty(repoName)
      let source = "No 'install' field provided in user settings.json"
    else
      let source = 'vim.org/' . repoName . ':'
    endif
  endif

  " 78 to account for the ends
  let leadSpace = repeat(" ", (78 - strchars(a:name))/2)
  let remainSpace = repeat(" ", 78 - strchars(leadSpace) - strchars(a:name))

  let updateButton = ""
  let statusButton = ""
  if a:update != ""
    let updateButton = "[+" . a:update . " ]"
  endif
  if a:status != ""
    let statusButton = "[ " . a:status . " ]"
  endif
  let buttons = updateButton . " " . statusButton
  let res = [
        \ "┌                                                                              ┐",
        \ "│". _VimBoxAlignLeft(source) . "│",
        \ "│". _VimBoxAlignLeft('  ' . a:description) . "│",
        \ "│". _VimBoxAlignRight(buttons) . "│",
        \ "└                                                                              ┘",
        \ ""
        \]
  return res
endfunction
function! _VimBoxSubheading(txt)
  let txt = a:txt . " "
  let txtLen = strchars(a:txt)
  return " " . txt . repeat(" ", 80 - txtLen - 3)
endfunction
function! _VimBoxPluginNameLine(txt, versionString)
  let txt = " " . a:txt . "  "
  let txtLen = strchars(txt)
  let versionString = "  " . a:versionString . " "
  let versionLen = strchars(versionString)
  return txt . repeat(" ", 80 - txtLen - versionLen) . versionString
endfunction
function! _VimBoxConfigLine(txt, valueString)
  let txt = a:txt
  let txtLen = strchars(txt)
  let valueString = ""
  if txtLen + strchars(a:valueString) > 78
    let valueString = "Value Too Long To Show"
  else
    let valueString = a:valueString
  endif
  let valLen = strchars(valueString)
  return txt . repeat(" ", 80 - txtLen - valLen) . valueString
endfunction

function! _VimBoxExplainMarkdown(keyPath)
  let byScope = VimBoxGetConfigChains(a:keyPath)
  let descriptionsByScope = VimBoxGetConfigChains(a:keyPath . ":description")
  let possibleValuesByScope = VimBoxGetConfigChains(a:keyPath . ":possibleValues")
  let description = ""
  let possibleValues = []
  if has_key(descriptionsByScope, '*')
    let descriptionEntries = descriptionsByScope['*']
    let descriptionEntry = v:null
    if type(descriptionEntries) == v:t_list && !empty(descriptionEntries)
      let firstEntry = descriptionEntries[0]
      if VimBoxHasValueFromResolvedConfigEntry(firstEntry)
        let description = VimBoxGetValueFromResolvedConfigEntry(firstEntry)
      endif
    endif
  endif
  if has_key(possibleValuesByScope, '*')
    let possibleValuesEntries = possibleValuesByScope['*']
    let possibleValuesEntry = v:null
    if type(possibleValuesEntries) == v:t_list && !empty(possibleValuesEntries)
      let firstEntry = possibleValuesEntries[0]
      if VimBoxHasValueFromResolvedConfigEntry(firstEntry)
        let possibleValues = VimBoxGetValueFromResolvedConfigEntry(firstEntry)
      endif
    endif
  endif
  let curFiletype = &filetype
  let forUniversalScope = []
  if has_key(byScope, '*')
    if !empty(byScope['*'])
      let forUniversalScope = byScope['*']
    endif
  endif
  let forFileTypeScope = []
  if has_key(byScope, curFiletype)
    if !empty(byScope[curFiletype])
      let forFileTypeScope = byScope[curFiletype]
    endif
  endif

  let all = empty(forFileTypeScope) ? forUniversalScope : extend(extend([], forUniversalScope), forFileTypeScope)
  " Add one to make room for user config added to end
  let output = []
  let finalValueString = ""
  if empty(all)
    let description = "Not configured for current filetype ('" . curFiletype . "')"
  else
    let i = 0
    let allLen = len(all)
    while i < allLen
      let entry = all[i]
      let origin = entry['origin']
      let config = entry['config']
      let finalValueString = "Not Set"
      if VimBoxHasValueFromResolvedConfigEntry(entry)
        let finalValueString = VimBoxValuePrint(VimBoxGetValueFromResolvedConfigEntry(entry))
      endif
      if i < len(forUniversalScope)
        let originLine = ": " . origin
        call extend(output, [originLine])
      else
        let originLine = ": " . origin . "(" . curFiletype . ")"
        call extend(output, [originLine])
      endif

      let i = i + 1
    endwhile
  endif
  let title = [_VimBoxConfigLine(a:keyPath, finalValueString)]
  if !empty(description)
    call extend(title, ["> " . description])
  endif
  if !empty(possibleValues)
    let j = 0
    let possibleLines = []
    while j < len(possibleValues)
      if has_key(possibleValues[j], 'value') && !has_key(possibleValues[j], 'description')
        call extend(possibleLines, ['  - ' . VimBoxValuePrint(possibleValues[j]['value'])])
      endif
      if has_key(possibleValues[j], 'value') && has_key(possibleValues[j], 'description')
        call extend(possibleLines, ['  - ' . VimBoxValuePrint(possibleValues[j]['value']), "  > " . possibleValues[j]['description']])
      endif
      let j = j + 1
    endwhile
    call extend(title, ["", "  Options:"])
    call extend(title, possibleLines)
  endif
  call extend(title, output)
  call extend(title, [""])
  return title
endfunction
