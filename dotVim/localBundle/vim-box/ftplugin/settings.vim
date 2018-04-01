

function! s:VimBoxSettingsFixHighlight()
  let bg=0
  let fg=1
  let pmenuSel = ColorToolsGetHighlight2(['PMenuSel', 'bg'], ['PMenuSel', 'fg'], 'none')
  let comment = ColorToolsGetHighlight2(['Comment', 'bg'], ['Comment', 'fg'], 'none')
  let commentFg = comment[fg]
  let commentBg = comment[bg]
  let string = ColorToolsGetHighlight2(['String', 'bg'], ['String', 'fg'], 'none')
  let stringFg = string[fg]
  let stringBg = string[bg]
  let norm = ColorToolsGetHighlight2(['Normal', 'bg'], ['Normal', 'fg'], 'none')
  let normalBg = norm[bg]
  let normalFg = norm[fg]
  let diffadd = ColorToolsGetHighlight2(['Normal', 'bg'], ['DiffAdd', 'bg'], 'none')
  let diffdeleted = ColorToolsGetHighlight2(['Normal', 'bg'], ['DiffDelete', 'bg'], 'none')
  let macro = ColorToolsGetHighlight2(['Normal', 'bg'], ['Macro', 'fg'], 'none')

  let panelBg = ColorToolsBlend(normalBg, normalFg, 10)
  let panelBgLight = ColorToolsBlend(normalBg, normalFg, 20)
  let panelFg = normalFg
  let headingConfigBg = diffdeleted[fg]
  let headingConfigFg = ColorToolsBlend(diffdeleted[bg], diffdeleted[fg], 10)
  let headingActionsBg = diffadd[fg]
  let headingActionsFg = ColorToolsBlend(diffadd[bg], diffadd[fg], 10)
  let headingMappingsBg = macro[fg]
  let headingMappingsFg = ColorToolsBlend(macro[bg], macro[fg], 10)
  let headingPluginBg = pmenuSel[bg]
  let headingPluginFg = ColorToolsBlend(pmenuSel[fg], pmenuSel[bg], 10)

  let panelButtonBg = ColorToolsBlend(normalBg, normalFg, 30)
  let panelButtonFg = normalFg
  let panelUpdateButtonBg = pmenuSel[bg]
  let panelUpdateButtonFg = pmenuSel[fg]

  call ColorToolsHighlight('ExplainConfigLine', normalFg, panelBg, 'bold')
  call ColorToolsHighlight('ExplainDetail', commentFg, commentBg, '')
  call ColorToolsHighlight('GlobalVariable', stringFg, stringBg, 'bold')
  call ColorToolsHighlight('ExplainDetailEnd', commentBg, commentBg, '')
  call ColorToolsHighlight('ExplainPanelTitle', normalFg, panelBg, 'bold')
  call ColorToolsHighlight('ExplainPanelTop',    panelBg, panelBg, 'bold')
  call ColorToolsHighlight('ExplainPanelBottom', panelBg, panelBg, 'bold')
  call ColorToolsHighlight('ExplainPanelSides', panelBg, panelBg, 'bold')
  call ColorToolsHighlight('ExplainPanel', normalFg, panelBg, '')
  call ColorToolsHighlight('ExplainHeadingConfig', headingConfigBg, panelBgLight, 'bold')
  call ColorToolsHighlight('ExplainHeadingActions', headingActionsBg, panelBgLight, 'bold')
  call ColorToolsHighlight('ExplainHeadingMappings', headingMappingsBg, panelBgLight, 'bold')
  call ColorToolsHighlight('ExplainHeadingConfigEnd', headingConfigFg, headingConfigBg, 'bold')
  call ColorToolsHighlight('ExplainHeadingActionsEnd', headingActionsFg, headingActionsBg, 'bold')
  call ColorToolsHighlight('ExplainHeadingMappingsEnd', headingMappingsFg, headingMappingsBg, 'bold')
  call ColorToolsHighlight('ExplainHeadingPlugin', headingPluginFg, headingPluginBg, 'bold')
  call ColorToolsHighlight('ExplainDescription', normalFg, normalBg, 'italic')
  call ColorToolsHighlight('ExplainDescriptionEnd', normalBg, normalBg, '')
  call ColorToolsHighlight('ExplainPanelUpdateButton', panelUpdateButtonFg, panelUpdateButtonBg, '')
  call ColorToolsHighlight('ExplainPanelUpdateButtonEnd', panelUpdateButtonBg, panelUpdateButtonBg, '')
  call ColorToolsHighlight('ExplainPanelButton', panelButtonFg, panelButtonBg, '')
  call ColorToolsHighlight('ExplainPanelButtonEnd', panelButtonBg, panelButtonBg, '')
endfunction

call s:VimBoxSettingsFixHighlight()

augroup ColorSchemeChanged
  autocmd!
  autocmd ColorScheme * :call s:VimBoxSettingsFixHighlight()
augroup END
