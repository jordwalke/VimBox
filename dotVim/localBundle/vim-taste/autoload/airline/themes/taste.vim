

" functions
" returns an approximate grey index for the given grey level

" Utility functions -------------------------------------------------------{{{
fun! <SID>grey_number(x)
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
fun! <SID>grey_level(n)
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
fun! <SID>grey_color(n)
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
fun! <SID>rgb_number(x)
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
fun! <SID>rgb_level(n)
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
fun! <SID>rgb_color(x, y, z)
  if &t_Co == 88
    return 16 + (a:x * 16) + (a:y * 4) + a:z
  else
    return 16 + (a:x * 36) + (a:y * 6) + a:z
  endif
endfun

" returns the palette index to approximate the given R/G/B color levels
fun! <SID>color(r, g, b)
  " get the closest grey
  let l:gx = <SID>grey_number(a:r)
  let l:gy = <SID>grey_number(a:g)
  let l:gz = <SID>grey_number(a:b)

  " get the closest color
  let l:x = <SID>rgb_number(a:r)
  let l:y = <SID>rgb_number(a:g)
  let l:z = <SID>rgb_number(a:b)

  if l:gx == l:gy && l:gy == l:gz
    " there are two possibilities
    let l:dgr = <SID>grey_level(l:gx) - a:r
    let l:dgg = <SID>grey_level(l:gy) - a:g
    let l:dgb = <SID>grey_level(l:gz) - a:b
    let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
    let l:dr = <SID>rgb_level(l:gx) - a:r
    let l:dg = <SID>rgb_level(l:gy) - a:g
    let l:db = <SID>rgb_level(l:gz) - a:b
    let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
    if l:dgrey < l:drgb
      " use the grey
      return <SID>grey_color(l:gx)
    else
      " use the color
      return <SID>rgb_color(l:x, l:y, l:z)
    endif
  else
    " only one possibility
    return <SID>rgb_color(l:x, l:y, l:z)
  endif
endfun

" returns the palette index to approximate the 'rrggbb' hex string
fun! <SID>rgb(rgb)
  let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
  let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
  let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0

  return <SID>color(l:r, l:g, l:b)
endfun

fun! <SID>blend(from, to, pct)

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

fun! <SID>blendBang(from, to, pct)
  return '#'.<SID>blend(a:from, a:to, a:pct)
endfun

" sets the highlighting for the given group
fun! <sid>X(...)
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
    let l:bg = " guibg=#" . l:bgArg . " ctermbg=" . <SID>rgb(l:bgArg)
  endif

  if l:fgArg != ''
    let l:fg = " guifg=#" . l:fgArg . " ctermfg=" . <SID>rgb(l:fgArg)
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



let g:airline#themes#taste#palette = {}

function! airline#themes#taste#refresh()
  let g:airline#themes#taste#palette.accents = {
        \ 'red': airline#themes#get_highlight('Constant'),
        \ }

  let s:N1_ = airline#themes#get_highlight2(['Normal', 'bg'], ['DiffAdd', 'bg'], 'none')
  let s:N1 = [
    \ <SID>blendBang(s:N1_[0], s:N1_[1], 10),
    \ s:N1_[1],
    \ s:N1_[2],
    \ s:N1_[3],
    \ s:N1_[4]
    \ ]
  let s:N2 = airline#themes#get_highlight('Pmenu')
  let s:N3 = airline#themes#get_highlight('StatusLine')
  let g:airline#themes#taste#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

  let normalGroup = airline#themes#get_highlight('Normal')
  let g:airline#themes#taste#palette.normal_modified = g:airline#themes#taste#palette.normal

  let s:I1_ = airline#themes#get_highlight2(['Normal', 'bg'], ['DiffLine', 'fg'], 'none')
  let s:I1 = [
    \ <SID>blendBang(s:I1_[0], s:I1_[1], 10),
    \ s:I1_[1],
    \ s:I1_[2],
    \ s:I1_[3],
    \ s:I1_[4]
    \ ]
  let s:I2 = airline#themes#get_highlight2(['MoreMsg', 'fg'], ['Normal', 'bg'])
  let s:I3 = s:N3
  let g:airline#themes#taste#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
  let g:airline#themes#taste#palette.insert_modified = g:airline#themes#taste#palette.insert

  let s:R1_ = airline#themes#get_highlight2(['Normal', 'bg'], ['Error', 'fg'], 'none')
  let s:R1 = [
    \ <SID>blendBang(s:R1_[0], s:R1_[1], 10),
    \ s:R1_[1],
    \ s:R1_[2],
    \ s:R1_[3],
    \ s:R1_[4]
    \ ]
  let s:R2 = s:N2
  let s:R3 = s:N3
  let g:airline#themes#taste#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
  let g:airline#themes#taste#palette.replace_modified = g:airline#themes#taste#palette.replace

  let s:V1_ = airline#themes#get_highlight2(['Normal', 'bg'], ['Statement', 'fg'], 'none')
  let s:V1 = [
    \ <SID>blendBang(s:V1_[0], s:V1_[1], 10),
    \ s:V1_[1],
    \ s:V1_[2],
    \ s:V1_[3],
    \ s:V1_[4]
    \ ]
  let s:V2 = s:N2
  let s:V3 = s:N3
  let g:airline#themes#taste#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
  let g:airline#themes#taste#palette.visual_modified = g:airline#themes#taste#palette.visual

  let s:IA = airline#themes#get_highlight2(['StatusLineNC', 'bg'], ['StatusLine', 'bg'])
  let g:airline#themes#taste#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
  let g:airline#themes#taste#palette.inactive_modified =g:airline#themes#taste#palette.inactive 

  " Warnings
  let s:WI = airline#themes#get_highlight2(['IncSearch', 'fg'], ['IncSearch', 'bg'], 'bold')
  let g:airline#themes#taste#palette.normal.airline_warning = [
       \ <SID>blendBang(s:WI[0], s:WI[1], 10), s:WI[1], s:WI[2], s:WI[3]
       \ ]

  let g:airline#themes#taste#palette.normal_modified.airline_warning =
      \ g:airline#themes#taste#palette.normal.airline_warning


  let g:airline#themes#taste#palette.insert.airline_warning =
      \ g:airline#themes#taste#palette.normal.airline_warning

  let g:airline#themes#taste#palette.insert_modified.airline_warning =
      \ g:airline#themes#taste#palette.normal.airline_warning

  let g:airline#themes#taste#palette.visual.airline_warning =
      \ g:airline#themes#taste#palette.normal.airline_warning

  let g:airline#themes#taste#palette.visual_modified.airline_warning =
      \ g:airline#themes#taste#palette.normal.airline_warning

  let g:airline#themes#taste#palette.replace.airline_warning =
      \ g:airline#themes#taste#palette.normal.airline_warning

  let g:airline#themes#taste#palette.replace_modified.airline_warning =
      \ g:airline#themes#taste#palette.normal.airline_warning

  " Errors
  let s:ER = airline#themes#get_highlight2(['Normal', 'bg'], ['DiffDelete', 'bg'], 'none')
  let g:airline#themes#taste#palette.normal.airline_error = [
       \ <SID>blendBang(s:ER[0], s:ER[1], 10), s:ER[1], s:ER[2], s:ER[3]
       \ ]

  let g:airline#themes#taste#palette.normal_modified.airline_error =
      \ g:airline#themes#taste#palette.normal.airline_error

  let g:airline#themes#taste#palette.insert.airline_error =
      \ g:airline#themes#taste#palette.normal.airline_error

  let g:airline#themes#taste#palette.insert_modified.airline_error =
      \ g:airline#themes#taste#palette.normal.airline_error

  let g:airline#themes#taste#palette.visual.airline_error =
      \ g:airline#themes#taste#palette.normal.airline_error

  let g:airline#themes#taste#palette.visual_modified.airline_error =
      \ g:airline#themes#taste#palette.normal.airline_error

  let g:airline#themes#taste#palette.replace.airline_error =
      \ g:airline#themes#taste#palette.normal.airline_error

  let g:airline#themes#taste#palette.replace_modified.airline_error =
      \ g:airline#themes#taste#palette.normal.airline_error

  let s:TM = airline#themes#get_highlight2(['StatusLineNC', 'bg'], ['StatusLine', 'bg'], 'none')
  let g:airline#themes#taste#palette.normal.airline_term = [ <SID>blendBang(s:TM[0], s:TM[1], 10), s:TM[1], s:TM[2], s:TM[3] ]
  let g:airline#themes#taste#palette.insert.airline_term  = g:airline#themes#taste#palette.normal.airline_term
  let g:airline#themes#taste#palette.visual.airline_term  = g:airline#themes#taste#palette.normal.airline_term 
  let g:airline#themes#taste#palette.replace.airline_term = g:airline#themes#taste#palette.normal.airline_term 
  
  " This doesn't solve the main problem of inactive.
  " let g:airline#themes#taste#palette.inactive.airline_term = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
  " let g:airline#themes#taste#palette.inactive_modified.airline_term = {
  "       \ 'airline_c': [ normalGroup[0], '', normalGroup[2], '', '' ]
  "       \ }

endfunction

call airline#themes#taste#refresh()
