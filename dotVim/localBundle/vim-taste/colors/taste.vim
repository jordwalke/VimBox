  " Name:    taste vim colorscheme
" Author:  Ramzi Akremi, modified by jordwalke
" License: MIT
" Version: 1.1.1-pre
" 
" Colors from:
" https://element.io/brand

" Global setup =============================================================={{{

let s:colorsBank = {
      \ 'strawberry': ['ff8c82', 'ed5353', 'c6262e', 'a10705', '7a0000'],
      \ 'orange':     ['ffc27d', 'ffa154', 'f37329', 'cc3b02', 'a62100'],
      \ 'banana':     ['fff394', 'ffe16b', 'f9c440', 'd48e15', 'ad5f00'],
      \ 'lime':       ['d1ff82', '9bdb4d', '68b723', '3a9104', '206b00'],
      \ 'blueberry':  ['8cd5ff', '64baff', '3689e6', '0d52bf', '002e99'],
      \ 'grape':      ['e4c6fa', 'cd9ef7', 'a56de2', '7239b3', '452981'],
      \ 'cocoa':      ['a3907c', '8a715e', '715344', '57392d', '3d211b'],
      \ 'silver':     ['fafafa', 'd4d4d4', 'abacae', '7e8087', '555761'],
      \ 'slate':      ['95a3ab', '667885', '485a6c', '273445', '0e141f'],
      \ 'black':      ['666666', '4d4d4d', '333333', '1a1a1a', '000000']
      \ }

function! s:colorsFor(brightness)
  return {
      \ 'strawberry': s:colorsBank['strawberry'][4-a:brightness],
      \ 'orange':     s:colorsBank['orange'][4-a:brightness],
      \ 'banana':     s:colorsBank['banana'][4-a:brightness],
      \ 'lime':       s:colorsBank['lime'][4-a:brightness],
      \ 'blueberry':  s:colorsBank['blueberry'][4-a:brightness],
      \ 'grape':      s:colorsBank['grape'][4-a:brightness],
      \ 'cocoa':      s:colorsBank['cocoa'][4-a:brightness],
      \ 'silver':     s:colorsBank['silver'][4-a:brightness],
      \ 'slate':      s:colorsBank['slate'][4-a:brightness],
      \ 'black':      s:colorsBank['black'][4-a:brightness]
      \ }
endfunction

" if !exists('g:taste_dark_brightness')
"   let g:taste_dark_brightness = 3
" endif

" if !exists('g:taste_light_brightness')
"   let g:taste_light_brightness = 2
" endif

let g:taste_dark_brightness = 3

let g:taste_light_brightness = 3


if g:taste_dark_brightness < 1 || g:taste_dark_brightness > 3
  " Leaves headroom to lighten or darken.
  call VimBoxUserMessageError("taste colorscheme configured with g:taste_dark_brightness outside valid range 1-3. saw " . g:taste_dark_brightness)
endif

if g:taste_light_brightness < 1 || g:taste_light_brightness > 3
  " Leaves headroom to lighten or darken.
  call VimBoxUserMessageError("taste colorscheme configured with g:taste_light_brightness outside valid range 1-3. saw " . g:taste_dark_brightness)
endif

hi clear
syntax reset
if exists('g:colors_name')
  unlet g:colors_name
endif
let g:colors_name = 'taste'

if !exists('g:taste_allow_italics')
  let g:taste_allow_italics = 0
endif

let g:hasGuiRunning = has('gui_running')

if has('gui_running') || &t_Co == 88 || &t_Co == 256 || &t_Co == 16777216
  " functions
  " returns an approximate grey index for the given grey level

  " Utility functions -------------------------------------------------------{{{
  fun <SID>grey_number(x)
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
  fun <SID>grey_level(n)
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
  fun <SID>grey_color(n)
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
  fun <SID>rgb_number(x)
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
  fun <SID>rgb_level(n)
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
  fun <SID>rgb_color(x, y, z)
    if &t_Co == 88
      return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
      return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
  endfun

  " returns the palette index to approximate the given R/G/B color levels
  fun <SID>color(r, g, b)
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
  fun <SID>rgb(rgb)
    let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
    let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
    let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0

    return <SID>color(l:r, l:g, l:b)
  endfun

  fun <SID>blend(from, to, pct)

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
  fun <SID>blendBang(from, to, pct)
    return '#'.<SID>blend(a:from, a:to, a:pct)
  endfun

  " sets the highlighting for the given group
  fun <sid>X(...)
    let l:groupArg = a:1
    let l:fgArg = a:2
    let l:bgArg = a:3
    let l:attrArg = a:4
    if g:taste_allow_italics == 0 && l:attrArg ==? 'italic'
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

    if a:0 >= 5 && a:5 != ''
      let l:guispArg = a:5
      let l:guisp = " guisp=#" . l:guispArg
    endif

    let l:exec = l:fg . l:bg . l:decoration . l:guisp

    if l:exec != ''
      exec "hi " . l:groupArg . l:exec
    endif
  endfun

  "}}}

  " Color definition --------------------------------------------------------{{{
  if &background ==# 'dark'
    let colorsLighter = s:colorsFor(g:taste_dark_brightness + 1)
    let colors = s:colorsFor(g:taste_dark_brightness)
    let colorsDarker = s:colorsFor(g:taste_dark_brightness - 1)
    let colorsDarkerer = s:colorsFor(g:taste_dark_brightness - 2)

    let s:cyan  = <SID>blend(colors['blueberry'], colorsLighter['blueberry'], 100)
    let s:blue  = <SID>blend(colors['blueberry'], colorsLighter['blueberry'], 0)
    let s:purple  = <SID>blend(colors['grape'], colorsLighter['grape'], 0)
    let s:green  = <SID>blend(colors['lime'], colorsLighter['lime'], 100)


    let s:red   = <SID>blend(colors['strawberry'], colorsLighter['strawberry'], 100)
    let s:red2 = <SID>blend(colors['strawberry'], colorsLighter['strawberry'], 0) " red 2

    let s:orange   = <SID>blend(colorsDarker['orange'], colors['orange'], 100) " orange 1
    let s:orange2 = <SID>blend(colorsDarker['orange'], colorsLighter['orange'], 100) " orange 2
    " Darkest to lightest:
    " - Text Buffer BG
    " - Chrome BG
    " - Modal BG

    " DARKEST BG:
    " ============
    " Syntax background.
    let s:syntax_bg = <SID>blend(colorsDarker['black'], colors['black'], 20)
    let s:fg = colors['silver']
    let s:fg_dim = colorsLighter['black']
    let s:syntax_fg = s:fg
    let s:syntax_fg_dim = s:fg_dim
    let s:syntax_fold_bg = s:syntax_fg_dim

    " DARK BG:
    " ============
    " Slightly lighter frame boundary colors
    let s:chrome_bg = <SID>blend(colorsDarker['black'], colors['black'], 50)
    let s:chrome_fg = s:fg
    let s:chrome_fg_dim = s:fg_dim
    " Text on chrome that should be less visible (deactivated pane chrome etc)
    let s:gutter_bg = s:chrome_bg
    let s:gutter_fg = s:fg_dim
    let s:gutter_fg_dim = s:fg_dim
    let s:vertsplit_bg = s:chrome_bg

    " LIGHTER BG:
    " ============
    " jordwalke: Slightly lighter than bg to make sure menus are visible
    " against chrome and menus are visible against bg.
    " modal_bg is things like popup menus, visual selection - things
    " generally overlayed on top of the background color that might bump up
    " against chrome as well.
    let s:modal_bg  = <SID>blend(colorsDarker['black'], colors['black'], 80)
    " modal_button_bg is things like popup menu scrollbar thumbs, wildmenu
    " cursor that may appear on top of modal_bg.
    let s:modal_button_bg  = <SID>blend(colors['black'], colorsLighter['black'], 0)
    let s:syntax_cursorline =  s:modal_bg

    let s:syntax_accent = colorsLighter['blueberry']
    let s:special_grey = 'ffffff' " NOT SURE WHAT THIS EVEN IS.

    " Have to add a slight tint to the visual otherwise it gets lost in the
    " chrome too easily. Purple is a nice choice because airline shows visual
    " mode as purple.
    let s:visual  = <SID>blend(s:modal_bg, colorsDarker['grape'], 8)


    " DIFF BGS:
    " ==============
    let s:diff_add_fg = <SID>blend(s:syntax_bg, s:green, 20)
    let s:diff_add_bg = s:green
    let s:diff_delete_fg = s:red
    " Recommended to hide this anyways: set fillchars=vert:\ ,diff:\ 
    let s:diff_delete_bg = <SID>blend(s:syntax_bg, s:diff_delete_fg, 20)

    
    " Search color should not resemble other colors in colorschemes.
    let s:search2   = colors['banana']
    let s:search  = colorsLighter['banana']
    let s:search2_bg  = <SID>blend(s:syntax_bg, s:search2, 15)
    let s:search_bg  = <SID>blend(s:syntax_bg, s:search, 5)

  else
    let colorsLighter = s:colorsFor(g:taste_light_brightness + 1)
    let colors = s:colorsFor(g:taste_light_brightness)
    let colorsDarker = s:colorsFor(g:taste_light_brightness - 1)
    let colorsDarkerer = s:colorsFor(g:taste_light_brightness - 2)

    let s:cyan  = <SID>blend(colorsDarkerer['blueberry'], colorsDarker['blueberry'], 0)
    let s:blue  = <SID>blend(colorsDarkerer['blueberry'], colorsDarker['blueberry'], 100)
    let s:purple  = <SID>blend(colorsDarkerer['grape'], colorsDarker['grape'], 0)
    let s:green  = <SID>blend(colorsDarkerer['lime'], colorsDarker['lime'], 0)


    let s:red   = <SID>blend(colorsDarkerer['strawberry'], colorsDarker['strawberry'], 100)
    let s:red2 = <SID>blend(colorsDarker['strawberry'], colors['strawberry'], 100) " red 2

    let s:orange   = <SID>blend(colorsDarkerer['banana'], colorsDarker['banana'], 0) " orange 1
    let s:orange2 = <SID>blend(colorsDarkerer['banana'], colorsDarker['banana'], 0) " orange 2

    " Darkest to lightest:
    " - Text Buffer BG
    " - Chrome BG
    " - Modal BG

    " DARKEST BG:
    " ============
    " Syntax background.
    let s:syntax_bg = <SID>blend(colors['silver'], colorsLighter['silver'], 80)
    let s:fg = colorsLighter['black']
    let s:fg_dim = colorsDarker['silver']
    let s:syntax_fg = s:fg
    let s:syntax_fg_dim = s:fg_dim
    let s:syntax_fold_bg = s:syntax_fg_dim

    " DARK BG:
    " ============
    " Slightly lighter frame boundary colors
    let s:chrome_bg = <SID>blend(colors['silver'], colorsLighter['silver'], 50)
    let s:chrome_fg = s:fg
    let s:chrome_fg_dim = s:fg_dim
    " Text on chrome that should be less visible (deactivated pane chrome etc)
    let s:gutter_bg = s:chrome_bg
    let s:gutter_fg = s:fg_dim
    let s:gutter_fg_dim = s:fg_dim
    let s:vertsplit_bg = s:chrome_bg

    " LIGHTER BG:
    " ============
    " jordwalke: Slightly lighter than bg to make sure menus are visible
    " against chrome and menus are visible against bg.
    " modal_bg is things like popup menus, visual selection - things
    " generally overlayed on top of the background color that might bump up
    " against chrome as well.
    let s:modal_bg  = <SID>blend(colors['silver'], colorsLighter['silver'], 30)
    " modal_button_bg is things like popup menu scrollbar thumbs, wildmenu
    " cursor that may appear on top of modal_bg.
    let s:modal_button_bg  = <SID>blend(colorsDarker['silver'], colors['silver'], 0)
    let s:syntax_cursorline =  s:modal_bg

    let s:syntax_accent = colorsDarker['blueberry']
    let s:special_grey = 'ffffff' " NOT SURE WHAT THIS EVEN IS.
    " Have to add a slight tint to the visual otherwise it gets lost in the
    " chrome too easily. Purple is a nice choice because airline shows visual
    " mode as purple.
    let s:visual  = <SID>blend(s:modal_bg, colorsDarker['grape'], 8)


    " DIFF BGS:
    " ==============
    let s:diff_add_fg = <SID>blend(s:syntax_bg, s:green, 20)
    let s:diff_add_bg = s:green
    let s:diff_delete_fg = s:red
    " Recommended to hide this anyways: set fillchars=vert:\ ,diff:\ 
    let s:diff_delete_bg = <SID>blend(s:syntax_bg, s:diff_delete_fg, 20)

    " Search color should not resemble other colors in colorschemes.
    let s:search2   = colorsDarker['banana']
    let s:search  = colors['banana']
    let s:search_bg  = s:syntax_fg
    let s:search2_bg  = <SID>blend(s:syntax_fg, s:search2, 15)
    let s:search_bg  = <SID>blend(s:syntax_fg, s:search, 5)

  endif

  "}}}

  " Vim editor color --------------------------------------------------------{{{
  call <sid>X('bold',         '',              '',               'bold')
  call <sid>X('ColorColumn',  '',              s:syntax_cursorline,  '')
  call <sid>X('Conceal',      '',              s:syntax_bg,               '')
  call <sid>X('Cursor',       s:syntax_bg,     s:blue,          '')
  call <sid>X('CursorIM',     '',              '',               '')
  call <sid>X('CursorColumn', '',              s:syntax_cursorline,  '')
  call <sid>X('CursorLine',   '',              s:syntax_cursorline,  'none')
  call <sid>X('Directory',    s:blue,         '',               '')
  call <sid>X('ErrorMsg',     s:red,         s:syntax_bg,      'none')
  " Strongly suggested:
  " set fillchars=vert:\ 
  call <sid>X('vertsplit',    s:vertsplit_bg,     s:gutter_bg,               'none')
  call <sid>X('Folded',       s:syntax_bg,     s:syntax_fold_bg, 'none')
  call <sid>X('FoldColumn',   s:fg_dim,        s:chrome_bg,  '')
  call <sid>X('IncSearch',    s:search_bg,     s:search,        'none')
  call <sid>X('LineNr',       s:gutter_fg,     s:gutter_bg,  '')
  call <sid>X('CursorLineNr', s:gutter_fg,     s:syntax_cursorline,  'none')
  call <sid>X('MatchParen',   s:syntax_bg,     s:red,          '')
  call <sid>X('Italic',       '',              '',               'italic')
  call <sid>X('ModeMsg',      s:syntax_fg,     '',               '')
  call <sid>X('MoreMsg',      s:syntax_fg,     '',               '')
  " jordwalke: Hide NonText clutter.
  call <sid>X('NonText',      s:syntax_bg,     s:syntax_bg,      '')
  call <sid>X('PMenu',        '',              s:modal_bg,    '')
  " jordwalke: make the popup stand out just a bit.
  call <sid>X('PMenuSel',     s:syntax_bg,              s:blue,  '')
  " jordwalke: Avoid floating scrollbar thumb.
  call <sid>X('PMenuSbar',    '',              s:modal_bg,      '')
  call <sid>X('PMenuThumb',   '',              s:modal_button_bg,         '')
  call <sid>X('Question',     s:blue,         '',               '')
  call <sid>X('Search',       s:search2_bg,     s:search2,        '')
  call <sid>X('SpecialKey',   s:special_grey,  '',               '')
  call <sid>X('StatusLine',   s:syntax_fg,     s:chrome_bg,  'none')
  " Remove the ugly grey nub (first param has to be chrome_bg - same as vertsplit_bg)
  call <sid>X('StatusLineNC', s:chrome_bg,     s:chrome_fg_dim,               '')
  call <sid>X('StatusLineTerm',   s:syntax_fg,     s:chrome_bg,  'none')
  call <sid>X('StatusLineTermNC', s:chrome_bg,     s:chrome_fg_dim,               'reverse')
  call <sid>X('TabLine',      s:fg,        s:chrome_bg,      'none')
  call <sid>X('TabLineFill',  s:chrome_fg_dim, s:chrome_bg,  'none')
  call <sid>X('TabLineSel',   s:blue,         s:syntax_bg,          '')
  call <sid>X('Title',        s:fg,         '',               'none')
  call <sid>X('Visual',       '',              s:visual,    '')
  call <sid>X('VisualNOS',    '',              s:modal_bg,    '')
  call <sid>X('WarningMsg',   s:red,         '',               '')
  call <sid>X('TooLong',      s:red,         '',               '')
  call <sid>X('WildMenu',     s:syntax_fg,     s:modal_button_bg,         '')
  call <sid>X('Normal',       s:syntax_fg,     s:syntax_bg,      '')
  call <sid>X('SignColumn',   '',              s:fg_dim,         '')
  call <sid>X('Special',      s:blue,         '',               '')
  " }}}

  " Standard syntax highlighting --------------------------------------------{{{
  call <sid>X('Comment',        s:syntax_fg_dim, '',          'italic')
  call <sid>X('Constant',       s:green,         '',          '')
  call <sid>X('String',         s:green,         '',          '')
  call <sid>X('Character',      s:green,         '',          '')
  call <sid>X('Number',         s:orange,         '',          '')
  call <sid>X('Boolean',        s:orange,         '',          '')
  call <sid>X('Float',          s:orange,         '',          '')
  call <sid>X('Identifier',     s:red,         '',          'none')
  call <sid>X('Function',       s:blue,         '',          '')
  call <sid>X('Statement',      s:purple,         '',          'none')
  call <sid>X('Conditional',    s:purple,         '',          '')
  call <sid>X('Repeat',         s:purple,         '',          '')
  call <sid>X('Label',          s:purple,         '',          '')
  call <sid>X('Operator',       s:syntax_accent, '',          'none')
  call <sid>X('Keyword',        s:red,         '',          '')
  call <sid>X('Exception',      s:purple,         '',          '')
  call <sid>X('PreProc',        s:orange2,       '',          '')
  call <sid>X('Include',        s:cyan,         '',          '')
  call <sid>X('Define',         s:purple,         '',          'none')
  call <sid>X('Macro',          s:purple,         '',          '')
  call <sid>X('PreCondit',      s:orange2,       '',          '')
  call <sid>X('Type',           s:orange2,       '',          'none')
  call <sid>X('StorageClass',   s:orange2,       '',          '')
  call <sid>X('Structure',      s:orange2,       '',          '')
  call <sid>X('Typedef',        s:orange2,       '',          '')
  call <sid>X('Special',        s:blue,         '',          '')
  call <sid>X('SpecialChar',    '',              '',          '')
  call <sid>X('Tag',            '',              '',          '')
  call <sid>X('Delimiter',      '',              '',          '')
  call <sid>X('SpecialComment', '',              '',          '')
  call <sid>X('Debug',          '',              '',          '')
  call <sid>X('Underlined',     '',              '',          '')
  call <sid>X('Ignore',         '',              '',          '')
  call <sid>X('Error',          s:red,         s:syntax_bg, 'bold')
  call <sid>X('Todo',           s:purple,         s:syntax_bg, '')
  " }}}

  " Diff highlighting -------------------------------------------------------{{{
  call <sid>X('DiffAdd',     s:diff_add_fg, s:diff_add_bg, '')
  call <sid>X('DiffChange',  '', s:chrome_bg, '')
  call <sid>X('DiffDelete',  s:diff_delete_bg, s:diff_delete_fg, '')
  call <sid>X('DiffText',    '', s:modal_bg, '')
  call <sid>X('DiffAdded',   s:diff_add_bg, s:modal_bg, '')
  call <sid>X('DiffFile',    s:red, s:modal_bg, '')
  call <sid>X('DiffNewFile', s:green, s:modal_bg, '')
  call <sid>X('DiffLine',    s:blue, s:modal_bg, '')
  call <sid>X('DiffRemoved', s:red, s:modal_bg, '')
  " }}}

  " Asciidoc highlighting ---------------------------------------------------{{{
  call <sid>X('asciidocListingBlock',   s:chrome_fg_dim,  '', '')
  " }}}

  " Cucumber highlighting ---------------------------------------------------{{{
  call <sid>X('cucumberGiven',           s:blue,  '', '')
  call <sid>X('cucumberWhen',            s:blue,  '', '')
  call <sid>X('cucumberWhenAnd',         s:blue,  '', '')
  call <sid>X('cucumberThen',            s:blue,  '', '')
  call <sid>X('cucumberThenAnd',         s:blue,  '', '')
  call <sid>X('cucumberUnparsed',        s:orange,  '', '')
  call <sid>X('cucumberFeature',         s:red,  '', 'bold')
  call <sid>X('cucumberBackground',      s:purple,  '', 'bold')
  call <sid>X('cucumberScenario',        s:purple,  '', 'bold')
  call <sid>X('cucumberScenarioOutline', s:purple,  '', 'bold')
  call <sid>X('cucumberTags',            s:fg_dim, '', 'bold')
  call <sid>X('cucumberDelimiter',       s:fg_dim, '', 'bold')
  " }}}

  " CSS/Sass highlighting ---------------------------------------------------{{{
  call <sid>X('cssAttrComma',         s:purple,  '', '')
  call <sid>X('cssAttributeSelector', s:green,  '', '')
  call <sid>X('cssBraces',            s:fg_dim, '', '')
  call <sid>X('cssClassName',         s:orange,  '', '')
  call <sid>X('cssClassNameDot',      s:orange,  '', '')
  call <sid>X('cssDefinition',        s:purple,  '', '')
  call <sid>X('cssFontAttr',          s:orange,  '', '')
  call <sid>X('cssFontDescriptor',    s:purple,  '', '')
  call <sid>X('cssFunctionName',      s:blue,  '', '')
  call <sid>X('cssIdentifier',        s:blue,  '', '')
  call <sid>X('cssImportant',         s:purple,  '', '')
  call <sid>X('cssInclude',           s:fg, '', '')
  call <sid>X('cssIncludeKeyword',    s:purple,  '', '')
  call <sid>X('cssMediaType',         s:orange,  '', '')
  call <sid>X('cssProp',              s:cyan,  '', '')
  call <sid>X('cssPseudoClassId',     s:orange,  '', '')
  call <sid>X('cssSelectorOp',        s:purple,  '', '')
  call <sid>X('cssSelectorOp2',       s:purple,  '', '')
  call <sid>X('cssStringQ',           s:fg, '', '')
  call <sid>X('cssStringQQ',          s:fg, '', '')
  call <sid>X('cssTagName',           s:red,  '', '')
  call <sid>X('cssAttr',              s:orange,  '', '')

  call <sid>X('sassAmpersand',      s:red,   '', '')
  call <sid>X('sassClass',          s:orange2, '', '')
  call <sid>X('sassControl',        s:purple,   '', '')
  call <sid>X('sassExtend',         s:purple,   '', '')
  call <sid>X('sassFor',            s:fg,  '', '')
  call <sid>X('sassProperty',       s:cyan,   '', '')
  call <sid>X('sassFunction',       s:cyan,   '', '')
  call <sid>X('sassId',             s:blue,   '', '')
  call <sid>X('sassInclude',        s:purple,   '', '')
  call <sid>X('sassMedia',          s:purple,   '', '')
  call <sid>X('sassMediaOperators', s:fg,  '', '')
  call <sid>X('sassMixin',          s:purple,   '', '')
  call <sid>X('sassMixinName',      s:blue,   '', '')
  call <sid>X('sassMixing',         s:purple,   '', '')
  " }}}

  " Elixir highlighting------------------------------------------------------{{{
  call <sid>X('elixirAlias',             s:orange2, '', '')
  call <sid>X('elixirAtom',              s:cyan,   '', '')
  call <sid>X('elixirBlockDefinition',   s:purple,   '', '')
  call <sid>X('elixirModuleDeclaration', s:orange,   '', '')
  " }}}

  " Git and git related plugins highlighting --------------------------------{{{
  call <sid>X('gitcommitComment',       s:fg_dim,  '', '')
  call <sid>X('gitcommitUnmerged',      s:green,   '', '')
  call <sid>X('gitcommitOnBranch',      '',        '', '')
  call <sid>X('gitcommitBranch',        s:purple,   '', '')
  call <sid>X('gitcommitDiscardedType', s:red,   '', '')
  call <sid>X('gitcommitSelectedType',  s:green,   '', '')
  call <sid>X('gitcommitHeader',        '',        '', '')
  call <sid>X('gitcommitUntrackedFile', s:cyan,   '', '')
  call <sid>X('gitcommitDiscardedFile', s:red,   '', '')
  call <sid>X('gitcommitSelectedFile',  s:green,   '', '')
  call <sid>X('gitcommitUnmergedFile',  s:orange2, '', '')
  call <sid>X('gitcommitFile',          '',        '', '')
  hi link gitcommitNoBranch       gitcommitBranch
  hi link gitcommitUntracked      gitcommitComment
  hi link gitcommitDiscarded      gitcommitComment
  hi link gitcommitSelected       gitcommitComment
  hi link gitcommitDiscardedArrow gitcommitDiscardedFile
  hi link gitcommitSelectedArrow  gitcommitSelectedFile
  hi link gitcommitUnmergedArrow  gitcommitUnmergedFile

  call <sid>X('SignifySignAdd',    s:green,   '', '')
  call <sid>X('SignifySignChange', s:orange2, '', '')
  call <sid>X('SignifySignDelete', s:red,   '', '')
  hi link GitGutterAdd    SignifySignAdd
  hi link GitGutterChange SignifySignChange
  hi link GitGutterDelete SignifySignDelete
  call <sid>X('diffAdded',         s:green,   '', '')
  call <sid>X('diffRemoved',       s:red,   '', '')
  " }}}

  " Go highlighting ---------------------------------------------------------{{{
  call <sid>X('goDeclaration',         s:purple, '', '')
  call <sid>X('goField',               s:red, '', '')
  call <sid>X('goMethod',              s:cyan, '', '')
  call <sid>X('goType',                s:purple, '', '')
  call <sid>X('goUnsignedInts',        s:cyan, '', '')
  " }}}

  " HTML highlighting -------------------------------------------------------{{{
  call <sid>X('htmlArg',            s:orange,  '', '')
  call <sid>X('htmlTagName',        s:red,  '', '')
  call <sid>X('htmlSpecialTagName', s:red,  '', '')
  call <sid>X('htmlTag',            s:fg_dim, '', '')
  " }}}

  " JavaScript highlighting -------------------------------------------------{{{
  call <sid>X('coffeeString',           s:green,   '', '')

  call <sid>X('javaScriptBraces',       s:fg_dim,  '', '')
  call <sid>X('javaScriptFunction',     s:purple,   '', '')
  call <sid>X('javaScriptIdentifier',   s:purple,   '', '')
  call <sid>X('javaScriptNull',         s:orange,   '', '')
  call <sid>X('javaScriptNumber',       s:orange,   '', '')
  call <sid>X('javaScriptRequire',      s:cyan,   '', '')
  call <sid>X('javaScriptReserved',     s:purple,   '', '')
  " https://github.com/pangloss/vim-javascript
  call <sid>X('jsArrowFunction',        s:purple,   '', '')
  call <sid>X('jsClassKeywords',        s:purple,   '', '')
  call <sid>X('jsDocParam',             s:blue,   '', '')
  call <sid>X('jsDocTags',              s:purple,   '', '')
  call <sid>X('jsFuncCall',             s:blue,   '', '')
  call <sid>X('jsFunction',             s:purple,   '', '')
  call <sid>X('jsGlobalObjects',        s:orange2, '', '')
  call <sid>X('jsModuleWords',          s:purple,   '', '')
  call <sid>X('jsModules',              s:purple,   '', '')
  call <sid>X('jsNull',                 s:orange,   '', '')
  call <sid>X('jsOperator',             s:purple,   '', '')
  call <sid>X('jsStorageClass',         s:purple,   '', '')
  call <sid>X('jsTemplateBraces',       s:red2, '', '')
  call <sid>X('jsTemplateVar',          s:green,   '', '')
  call <sid>X('jsThis',                 s:red,   '', '')
  call <sid>X('jsUndefined',            s:orange,   '', '')
  " https://github.com/othree/yajs.vim
  call <sid>X('javascriptArrowFunc',    s:purple,   '', '')
  call <sid>X('javascriptClassExtends', s:purple,   '', '')
  call <sid>X('javascriptClassKeyword', s:purple,   '', '')
  call <sid>X('javascriptDocNotation',  s:purple,   '', '')
  call <sid>X('javascriptDocParamName', s:blue,   '', '')
  call <sid>X('javascriptDocTags',      s:purple,   '', '')
  call <sid>X('javascriptEndColons',    s:fg_dim,  '', '')
  call <sid>X('javascriptExport',       s:purple,   '', '')
  call <sid>X('javascriptFuncArg',      s:fg,  '', '')
  call <sid>X('javascriptFuncKeyword',  s:purple,   '', '')
  call <sid>X('javascriptIdentifier',   s:red,   '', '')
  call <sid>X('javascriptImport',       s:purple,   '', '')
  call <sid>X('javascriptObjectLabel',  s:fg,  '', '')
  call <sid>X('javascriptOpSymbol',     s:cyan,   '', '')
  call <sid>X('javascriptOpSymbols',    s:cyan,   '', '')
  call <sid>X('javascriptPropertyName', s:green,   '', '')
  call <sid>X('javascriptTemplateSB',   s:red2, '', '')
  call <sid>X('javascriptVariable',     s:purple,   '', '')
  " }}}

  " JSON highlighting -------------------------------------------------------{{{
  call <sid>X('jsonCommentError',      s:fg, '', ''        )
  call <sid>X('jsonKeyword',           s:red,  '', ''        )
  call <sid>X('jsonQuote',             s:fg_dim, '', ''        )
  call <sid>X('jsonMissingCommaError', s:red,  '', 'reverse' )
  call <sid>X('jsonNoQuotesError',     s:red,  '', 'reverse' )
  call <sid>X('jsonNumError',          s:red,  '', 'reverse' )
  call <sid>X('jsonString',            s:green,  '', ''        )
  call <sid>X('jsonStringSQError',     s:red,  '', 'reverse' )
  call <sid>X('jsonSemicolonError',    s:red,  '', 'reverse' )
  " }}}

  " Markdown highlighting ---------------------------------------------------{{{
  call <sid>X('markdownUrl',              s:fg_dim,  '', '')
  " Heading rules are the ==== and --- below a heading
  call <sid>X('markdownHeadingRule',      s:fg_dim,  '', '')
  " Rules also include free floating rules like - - - - and * * * * *
  call <sid>X('markdownRule',             s:fg_dim,  '', '')
  
  call <sid>X('markdownBlockquote',       s:fg_dim, s:modal_bg , '')
  call <sid>X('markdownBlock',       s:fg_dim,  s:fg_dim, 'italic')
  call <sid>X('markdownBold',             s:orange,   '', 'bold')
  call <sid>X('markdownBoldItalic',       s:orange,   '', 'bold,italic')
  call <sid>X('markdownItalic',           s:blue,   '', 'italic')
  call <sid>X('markdownCode',             s:green,   s:modal_bg, '')
  call <sid>X('markdownCodeBlock',        s:red,   '', '')
  call <sid>X('markdownCodeDelimiter',    s:fg_dim,   '', '')
  call <sid>X('markdownHeadingDelimiter', s:red, '', '')
  call <sid>X('markdownH1',               s:red,         '', 'bold')
  call <sid>X('markdownH2',               s:red,         '', 'bold')
  call <sid>X('markdownH3',               s:syntax_fg,   '', 'bold')
  call <sid>X('markdownH3',               s:syntax_fg,   '', 'bold')
  call <sid>X('markdownH4',               s:syntax_fg,   '', '')
  call <sid>X('markdownH5',               s:syntax_fg,   '', '')
  call <sid>X('markdownH6',               s:syntax_fg,   '', '')
  call <sid>X('markdownListMarker',       s:red,   '', 'bold')
  " }}}

  " PHP highlighting --------------------------------------------------------{{{
  call <sid>X('phpClass',        s:orange2, '', '')
  call <sid>X('phpFunction',     s:blue,   '', '')
  call <sid>X('phpFunctions',    s:blue,   '', '')
  call <sid>X('phpInclude',      s:purple,   '', '')
  call <sid>X('phpKeyword',      s:purple,   '', '')
  call <sid>X('phpParent',       s:fg_dim,  '', '')
  call <sid>X('phpType',         s:purple,   '', '')
  call <sid>X('phpSuperGlobals', s:red,   '', '')
  " }}}

  " Pug (Formerly Jade) highlighting ----------------------------------------{{{
  call <sid>X('pugAttributesDelimiter',   s:orange,    '', '')
  call <sid>X('pugClass',                 s:orange,    '', '')
  call <sid>X('pugDocType',               s:fg_dim,   '', 'italic')
  call <sid>X('pugTag',                   s:red,    '', '')
  " }}}

  " Ruby highlighting -------------------------------------------------------{{{
  call <sid>X('rubyBlock',                     s:purple,   '', '')
  call <sid>X('rubyBlockParameter',            s:red,   '', '')
  call <sid>X('rubyBlockParameterList',        s:red,   '', '')
  call <sid>X('rubyCapitalizedMethod',         s:purple,   '', '')
  call <sid>X('rubyClass',                     s:purple,   '', '')
  call <sid>X('rubyConstant',                  s:orange2, '', '')
  call <sid>X('rubyControl',                   s:purple,   '', '')
  call <sid>X('rubyDefine',                    s:purple,   '', '')
  call <sid>X('rubyEscape',                    s:red,   '', '')
  call <sid>X('rubyFunction',                  s:blue,   '', '')
  call <sid>X('rubyGlobalVariable',            s:red,   '', '')
  call <sid>X('rubyInclude',                   s:blue,   '', '')
  call <sid>X('rubyIncluderubyGlobalVariable', s:red,   '', '')
  call <sid>X('rubyInstanceVariable',          s:red,   '', '')
  call <sid>X('rubyInterpolation',             s:cyan,   '', '')
  call <sid>X('rubyInterpolationDelimiter',    s:red,   '', '')
  call <sid>X('rubyKeyword',                   s:blue,   '', '')
  call <sid>X('rubyModule',                    s:purple,   '', '')
  call <sid>X('rubyPseudoVariable',            s:red,   '', '')
  call <sid>X('rubyRegexp',                    s:cyan,   '', '')
  call <sid>X('rubyRegexpDelimiter',           s:cyan,   '', '')
  call <sid>X('rubyStringDelimiter',           s:green,   '', '')
  call <sid>X('rubySymbol',                    s:cyan,   '', '')
  " }}}

  " Spelling highlighting ---------------------------------------------------{{{
  " Even if no gui_running, Kitty (and VTE) will render undercurls if you set:
  " 
  "   let &t_Cs = "\e[4:3m\e[58;5;9m"
  "   let &t_Ce = "\e[4:0m\e[59m"
  "
  " But note that the ;9m sets it to the terminal red color.
  " Instead we should read from the actual colors to set the terminal colors
  " according to the color scheme. Coming soon: A plugin in VimBox that sets
  " that escape code upon every colorscheme change.
  call <sid>X('SpellBad',     '', s:syntax_bg, 'undercurl', s:red)
  call <sid>X('SpellLocal',   '', s:syntax_bg, 'undercurl')
  call <sid>X('SpellCap',     '', s:syntax_bg, 'undercurl', s:orange)
  call <sid>X('SpellRare',    '', s:syntax_bg, 'undercurl')
  " }}}

  " Vim highlighting --------------------------------------------------------{{{
  call <sid>X('vimCommand',      s:blue,  '', '')
  call <sid>X('vimCommentTitle', s:syntax_fg_dim, '', 'bold')
  call <sid>X('vimFunction',     s:cyan,  '', '')
  call <sid>X('vimFuncName',     s:purple,  '', '')
  call <sid>X('vimHighlight',    s:blue,  '', '')
  call <sid>X('vimLineComment',  s:syntax_fg_dim, '', 'italic')
  call <sid>X('vimParenSep',     s:syntax_fg_dim, '', '')
  call <sid>X('vimSep',          s:syntax_fg_dim, '', '')
  call <sid>X('vimUserFunc',     s:cyan,  '', '')
  call <sid>X('vimVar',          s:red,  '', '')
  " }}}

  " XML highlighting --------------------------------------------------------{{{
  call <sid>X('xmlAttrib',  s:orange2, '', '')
  call <sid>X('xmlEndTag',  s:red,   '', '')
  call <sid>X('xmlTag',     s:red,   '', '')
  call <sid>X('xmlTagName', s:red,   '', '')
  " }}}

  " ZSH highlighting --------------------------------------------------------{{{
  call <sid>X('zshCommands',     s:syntax_fg, '', '')
  call <sid>X('zshDeref',        s:red,     '', '')
  call <sid>X('zshShortDeref',   s:red,     '', '')
  call <sid>X('zshFunction',     s:cyan,     '', '')
  call <sid>X('zshKeyword',      s:purple,     '', '')
  call <sid>X('zshSubst',        s:red,     '', '')
  call <sid>X('zshSubstDelim',   s:syntax_fg_dim,    '', '')
  call <sid>X('zshTypes',        s:purple,     '', '')
  call <sid>X('zshVariableDef',  s:orange,     '', '')
  " }}}

  " Delete functions =========================================================={{{
  delf <SID>X
  delf <SID>rgb
  delf <SID>color
  delf <SID>rgb_color
  delf <SID>rgb_level
  delf <SID>rgb_number
  delf <SID>grey_color
  delf <SID>grey_level
  delf <SID>blend
  delf <SID>blendBang
  delf <SID>grey_number
  "}}}

endif
"}}}

" vim: set fdl=0 fdm=marker:
