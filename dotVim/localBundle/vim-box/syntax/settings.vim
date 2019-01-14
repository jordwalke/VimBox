
syn match ExplainConfigLine /^\S*\.\S*\.\S*\s\+.*/
syn region ExplainHeadingConfig matchgroup=ExplainHeadingConfigEnd start="^ config " end="$" keepend contains=TOP
syn region ExplainHeadingActions matchgroup=ExplainHeadingActionsEnd start="^ actions " end="$" keepend contains=TOP
syn region ExplainHeadingMappings matchgroup=ExplainHeadingMappingsEnd start="^ mappings " end="$" keepend contains=TOP

" For the :Where command
syn region ExplainLocationSection matchgroup=ExplainLocationSectionEnd start="^ User Config " end="$" keepend contains=TOP
syn region ExplainLocationSection matchgroup=ExplainLocationSectionEnd start="^ User Data " end="$" keepend contains=TOP
syn region ExplainLocationSection matchgroup=ExplainLocationSectionEnd start="^ VimBox Installation " end="$" keepend contains=TOP
syn region ExplainLocationSection matchgroup=ExplainLocationSectionEnd start="^ Cache Data " end="$" keepend contains=TOP
syn match ExplainTitle /^\s\+VimBox Locations\s*/

syn match ExplainHeadingPlugin /^ \S* .*  .*$/

syn match ExplainPanelTop /┌.*┐/
syn match ExplainPanelBottom /└.*┘/
syn region ExplainPanel matchgroup=ExplainPanelSides start="│" end="│" keepend contains=TOP
syn match ExplainPanelTitle /[^:]*:/ containedin=ExplainPanel contained
" ┌───────────────────┐
" │        enabled  │
" └───────────────────┘

" ┌───────────────────┐
" │        █enabled │
" └───────────────────┘
syn region ExplainDescription matchgroup=ExplainDescriptionEnd start="^\s*>" keepend end="$"


syn match ExplainDetail /^\s*:.*$/
syn region ExplainDetail matchgroup=ExplainDetailEnd start="^\s*:" end="^" keepend

syn match GlobalVariable /^\s*g:[a-zA-Z0-9_]* = .*$/

hi def link configKeyword   Keyword

" syn match ExplainButtonStart //
" syn match ExplainButtonEnd //
" syn match ExplainButton /.*/me=e-1

" These powerline endpoints are difficult to render reliably in all powerline
" fonts.
" syn region ExplainPanelButton matchgroup=ExplainPanelButtonEnd start="" end="" containedin=ExplainPanel contained
" syn region ExplainHeadingButton matchgroup=ExplainHeadingButtonEnd start="" end="" containedin=ExplainHeading contained
  "enabled
" Instead we'll render square buttons.
syn region ExplainPanelButton matchgroup=ExplainPanelButtonEnd start="\[" end="\]" keepend containedin=ExplainPanel contained
syn region ExplainPanelUpdateButton matchgroup=ExplainPanelUpdateButtonEnd start="\[+" end="\]" keepend containedin=ExplainPanel contained
