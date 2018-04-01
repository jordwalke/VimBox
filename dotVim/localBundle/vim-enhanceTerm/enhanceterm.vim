if exists("g:loaded_enhanceterm")
  finish
endif

let g:loaded_enhanceterm=1

" If there was a way to set the undercurl color explicitl with t_Cs instead of
" pulling color number "9" (usually red), then on every color scheme change,
" we'd use color-tools to pull out the color of Error and reset t_Cs with it.
" augroup ColorSchemeChanged
"   autocmd!
"   autocmd ColorScheme * :call s:EnhanceTermAdjustUndercurlColor()
" augroup END
