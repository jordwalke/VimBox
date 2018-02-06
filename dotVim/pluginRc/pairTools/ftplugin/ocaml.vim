let g:pairtools_ocaml_pairclamp = 1

" Tag wrench mode remaps <Esc> in insert mode which prevents having your
" terminal (iTerm) remap comand+s to escape sequences.  Disabling tag wrench,
" but you may enable later if you guard this setting under:
" if exists("g:gui_oni") || has('gui') && has('mac') && has('gui_running')
"   let g:pairtools_ocaml_tagwrench = 1
" endif
let g:pairtools_ocaml_jigsaw    = 1
let g:pairtools_ocaml_autoclose  = 1
let g:pairtools_ocaml_forcepairs = 0
let g:pairtools_ocaml_closepairs = "(:),[:],{:},':'" . ',":"'
let g:pairtools_ocaml_smartclose = 1
let g:pairtools_ocaml_smartcloserules = '\w,(,&,\*'
let g:pairtools_ocaml_antimagic  = 1
let g:pairtools_ocaml_antimagicfield  = "Comment,String,Special"
let g:pairtools_ocaml_pcexpander = 1
let g:pairtools_ocaml_pceraser   = 1
let g:pairtools_ocaml_tagwrenchhook = 'tagwrench#BuiltinNoHook'
let g:pairtools_ocaml_twexpander = 0
let g:pairtools_ocaml_tweraser   = 0
let g:pairtools_ocaml_apostrophe = 1
