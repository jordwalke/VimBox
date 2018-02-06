let g:pairtools_reason_pairclamp = 1
" Tag wrench mode remaps <Esc> in insert mode which prevents having your
" terminal (iTerm) remap comand+s to escape sequences.  Disabling tag wrench,
" but you may enable later if you guard this setting under:
" if exists("g:gui_oni") || has('gui') && has('mac') && has('gui_running')
"   let g:pairtools_ocaml_tagwrench = 1
" endif
let g:pairtools_reason_tagwrench = 0
let g:pairtools_reason_jigsaw    = 1
let g:pairtools_reason_autoclose  = 1
let g:pairtools_reason_forcepairs = 0
let g:pairtools_reason_closepairs = "(:),[:],{:},':'" . ',":"'
let g:pairtools_reason_smartclose = 1
let g:pairtools_reason_smartcloserules = '\w,(,&,\*'
let g:pairtools_reason_antimagic  = 1
let g:pairtools_reason_antimagicfield  = "Comment,String,Special"
let g:pairtools_reason_pcexpander = 1
let g:pairtools_reason_pceraser   = 1
let g:pairtools_reason_tagwrenchhook = 'tagwrench#BuiltinHTML5Hook'
let g:pairtools_reason_twexpander = 1
let g:pairtools_reason_tweraser   = 0
let g:pairtools_reason_apostrophe = 1
