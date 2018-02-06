" TagWrench and this plugin in general are quite amazing.
" apostrophe has odd behavior when inserting a method call here (|)
" autocmd FileType javascript let g:pairtools_javascript_tagwrench = 1
let g:pairtools_javascript_tagwrenchhook = 'tagwrench#BuiltinHTML5Hook'
let g:pairtools_javascript_twexpander = 1
let g:pairtools_javascript_tweraser   = 1
" Tag wrench mode remaps <Esc> in insert mode which prevents having your
" terminal (iTerm) remap comand+s to escape sequences.  Disabling tag wrench,
" but you may enable later if you guard this setting under:
" if exists("g:gui_oni") || has('gui') && has('mac') && has('gui_running')
"   let g:pairtools_ocaml_tagwrench = 1
" endif
let g:pairtools_javascript_tagwrench = 0
let g:pairtools_javascript_apostrophe = 0
let g:pairtools_javascript_jigsaw    = 1
