" functions
" returns an approximate grey index for the given grey level

let s:guiMode = has('gui_running') || ( has("termguicolors") && &termguicolors == 1 ) ?  'gui' : 'cterm'

" Utility functions -------------------------------------------------------{{{
fun! ColorToolsGreyNumber(x)
  if &t_Co == 88
    if a:x < 23
      return 0
    elseif a:x < 69
      return 1
    elseif a:x < 103
      return 2
    elseif a:x < 127
      return 3
    elseif a:x < 150
      return 4
    elseif a:x < 173
      return 5
    elseif a:x < 196
      return 6
    elseif a:x < 219
      return 7
    elseif a:x < 243
      return 8
    else
      return 9
    endif
  else
    if a:x < 14
      return 0
    else
      let l:n = (a:x - 8) / 10
      let l:m = (a:x - 8) % 10
      if l:m < 5
        return l:n
      else
        return l:n + 1
      endif
    endif
  endif
endfun

" returns the actual grey level represented by the grey index
fun! ColorToolsGreyLevel(n)
  if &t_Co == 88
    if a:n == 0
      return 0
    elseif a:n == 1
      return 46
    elseif a:n == 2
      return 92
    elseif a:n == 3
      return 115
    elseif a:n == 4
      return 139
    elseif a:n == 5
      return 162
    elseif a:n == 6
      return 185
    elseif a:n == 7
      return 208
    elseif a:n == 8
      return 231
    else
      return 255
    endif
  else
    if a:n == 0
      return 0
    else
      return 8 + (a:n * 10)
    endif
  endif
endfun

" returns the palette index for the given grey index
fun! ColorToolsGreyColor(n)
  if &t_Co == 88
    if a:n == 0
      return 16
    elseif a:n == 9
      return 79
    else
      return 79 + a:n
    endif
  else
    if a:n == 0
      return 16
    elseif a:n == 25
      return 231
    else
      return 231 + a:n
    endif
  endif
endfun

" returns an approximate color index for the given color level
fun! ColorToolsRgbNumber(x)
  if &t_Co == 88
    if a:x < 69
      return 0
    elseif a:x < 172
      return 1
    elseif a:x < 230
      return 2
    else
      return 3
    endif
  else
    if a:x < 75
      return 0
    else
      let l:n = (a:x - 55) / 40
      let l:m = (a:x - 55) % 40
      if l:m < 20
        return l:n
      else
        return l:n + 1
      endif
    endif
  endif
endfun

" returns the actual color level for the given color index
fun! ColorToolsRgbLevel(n)
  if &t_Co == 88
    if a:n == 0
      return 0
    elseif a:n == 1
      return 139
    elseif a:n == 2
      return 205
    else
      return 255
    endif
  else
    if a:n == 0
      return 0
    else
      return 55 + (a:n * 40)
    endif
  endif
endfun

" returns the palette index for the given R/G/B color indices
fun! ColorToolsRgbColor(x, y, z)
  if &t_Co == 88
    return 16 + (a:x * 16) + (a:y * 4) + a:z
  else
    return 16 + (a:x * 36) + (a:y * 6) + a:z
  endif
endfun

" returns the palette index to approximate the given R/G/B color levels
fun! ColorToolsColor(r, g, b)
  " get the closest grey
  let l:gx = ColorToolsGreyNumber(a:r)
  let l:gy = ColorToolsGreyNumber(a:g)
  let l:gz = ColorToolsGreyNumber(a:b)

  " get the closest color
  let l:x = ColorToolsRgbNumber(a:r)
  let l:y = ColorToolsRgbNumber(a:g)
  let l:z = ColorToolsRgbNumber(a:b)

  if l:gx == l:gy && l:gy == l:gz
    " there are two possibilities
    let l:dgr = ColorToolsGreyLevel(l:gx) - a:r
    let l:dgg = ColorToolsGreyLevel(l:gy) - a:g
    let l:dgb = ColorToolsGreyLevel(l:gz) - a:b
    let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
    let l:dr = ColorToolsRgbLevel(l:gx) - a:r
    let l:dg = ColorToolsRgbLevel(l:gy) - a:g
    let l:db = ColorToolsRgbLevel(l:gz) - a:b
    let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
    if l:dgrey < l:drgb
      " use the grey
      return ColorToolsGreyColor(l:gx)
    else
      " use the color
      return ColorToolsRgbColor(l:x, l:y, l:z)
    endif
  else
    " only one possibility
    return ColorToolsRgbColor(l:x, l:y, l:z)
  endif
endfun

" returns the palette index to approximate the 'rrggbb' hex string
fun! ColorToolsRgb(rgb)
  let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
  let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
  let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0

  return ColorToolsColor(l:r, l:g, l:b)
endfun

fun! ColorToolsBlend(from, to, pct)

  let l:from = strpart(a:from, 0, 1) == '#' ? strpart(a:from, 1, 6) : a:from
  let l:to = strpart(a:to, 0, 1) == '#' ? strpart(a:to, 1, 6) : a:to
  let l:from_r = ('0x' . strpart(l:from, 0, 2)) + 0
  let l:from_g = ('0x' . strpart(l:from, 2, 2)) + 0
  let l:from_b = ('0x' . strpart(l:from, 4, 2)) + 0
  let l:to_r = ('0x' . strpart(l:to, 0, 2)) + 0
  let l:to_g = ('0x' . strpart(l:to, 2, 2)) + 0
  let l:to_b = ('0x' . strpart(l:to, 4, 2)) + 0
  let l:r = l:from_r + ((l:to_r - l:from_r) * a:pct)/100
  let l:g = l:from_g + ((l:to_g - l:from_g) * a:pct)/100
  let l:b = l:from_b + ((l:to_b - l:from_b) * a:pct)/100
  return printf('%02x%02x%02x', l:r, l:g, l:b) 
endfun
fun! ColorToolsBlendBang(from, to, pct)
  return '#'.ColorToolsBlend(a:from, a:to, a:pct)
endfun

" sets the highlighting for the given group
fun! ColorToolsHighlight(...)
  let l:groupArg = a:1
  let l:fgArg = a:2
  let l:bgArg = a:3
  let l:attrArg = a:4
  if g:one_allow_italics == 0 && l:attrArg ==? 'italic'
      let l:attrArg= 'none'
  endif

  let l:bg = ""
  let l:fg = ""
  let l:guisp = ""
  let l:decoration = ""

  if l:bgArg != ''
    let l:bg = " guibg=#" . l:bgArg . " ctermbg=" . ColorToolsRgb(l:bgArg)
  endif

  if l:fgArg != ''
    let l:fg = " guifg=#" . l:fgArg . " ctermfg=" . ColorToolsRgb(l:fgArg)
  endif

  if l:attrArg != ''
    let l:decoration = " gui=" . l:attrArg . " cterm=" . l:attrArg
  endif

  if g:hasGuiRunning && a:0 >= 5 && a:5 != ''
    let l:guispArg = a:5
    let l:guisp = " guisp=#" . l:guispArg
  endif

  let l:exec = l:fg . l:bg . l:decoration . l:guisp

  if l:exec != ''
    exec "hi " . l:groupArg . l:exec
  endif
endfun

"}}}


" The remaining functions were gotten from vim-airline
function! s:ColorToolsGetSyn(group, what)
  let color = ''
  if hlexists(a:group)
    let color = synIDattr(synIDtrans(hlID(a:group)), a:what, s:guiMode)
  endif
  if empty(color) || color == -1
    " should always exists
    let color = synIDattr(synIDtrans(hlID('Normal')), a:what, s:guiMode)
    " however, just in case
    if empty(color) || color == -1
      let color = 'NONE'
    endif
  endif
  let ret = strpart(color, 0, 1) == '#' ? strpart(color, 1, 6) : color
  return ret
endfunction

function! s:ColorToolsGetArray(fg, bg, opts)
  let opts=empty(a:opts) ? '' : join(a:opts, ',')
  return s:guiMode ==# 'gui'
        \ ? [ a:fg, a:bg, '', '', opts ]
        \ : [ '', '', a:fg, a:bg, opts ]
endfunction
function! ColorToolsGetHighlight(group, ...)
  let fg = s:ColorToolsGetSyn(a:group, 'fg')
  let bg = s:ColorToolsGetSyn(a:group, 'bg')
  let reverse = s:guiMode ==# 'gui'
        \ ? synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'gui')
        \ : synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'cterm')
        \|| synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'term')
  let bold = synIDattr(synIDtrans(hlID(a:group)), 'bold')
  let opts = a:000
  if bold
    let opts = ['bold']
  endif
  let res = reverse ? s:ColorToolsGetArray(bg, fg, opts) : s:ColorToolsGetArray(fg, bg, opts)
  return res
endfunction

function! ColorToolsGetHighlight2(fg, bg, ...)
  let fg = s:ColorToolsGetSyn(a:fg[0], a:fg[1])
  let bg = s:ColorToolsGetSyn(a:bg[0], a:bg[1])
  return s:ColorToolsGetArray(fg, bg, a:000)
endfunction
