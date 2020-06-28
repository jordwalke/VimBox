" Define these pairtools for help files, even though help files are read only
" - just to work around a bug in pairtools where the help window causes an
"   error the *second* time you open it.
let g:pairtools_help_pairclamp = 0
let g:pairtools_help_pairclamp = 0
let g:pairtools_help_tagwrench = 0
let g:pairtools_help_jigsaw    = 0
let g:pairtools_help_tagwrench = 0
let g:pairtools_help_jigsaw    = 0
" Saw this form in the implementation - not sure what the diff is
let g:jigsaw_help_enable    = 0
let g:pairtools_help_autoclose  = 1
let g:pairtools_help_forcepairs = 0
let g:pairtools_help_closepairs = "(:),[:],{:},':'" . ',":"'
let g:pairtools_help_smartclose = 1
let g:pairtools_help_smartcloserules = '\w,(,&,\*'
let g:pairtools_help_antimagic  = 1
let g:pairtools_help_antimagicfield  = "Comment,String,Special"
let g:pairtools_help_pcexpander = 1
let g:pairtools_help_pceraser   = 1
let g:pairtools_help_tagwrenchhook = 'tagwrench#BuiltinNoHook'
let g:pairtools_help_twexpander = 0
let g:pairtools_help_tweraser   = 0
let g:pairtools_help_apostrophe = 0
