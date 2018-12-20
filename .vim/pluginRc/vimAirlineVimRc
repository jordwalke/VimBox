let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
" Git status can be expensive.
let g:airline#extensions#branch#enabled = 0
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
set laststatus=2
" Disable truncation
" let g:airline#extensions#default#section_truncate_width = {}

function! AirlineInit()
  " This has to be configured after plugins are loaded.
  call airline#parts#define_condition('ffenc', '&fileformat != "unix" || &fileencoding != "utf-8" && &fileencoding != ""')
  function! GetSyntasticErrors()
    let spc = g:airline_symbols.space
    " Trick: Warning prints one space, error prints two.
    let g:syntastic_stl_format = '%W{ }%E{  }'
    let errors = SyntasticStatuslineFlag()
    let len = strlen(errors)
    " 0, No errors no warning. syntasticOk will take up all the space, 1, 
    if len == 0 || len == 1
      return ''
    endif
    " This must be a warning. Warning will take up all the space.
    if len == 1
      return ''
    endif
    " Only errors, no warnings.
    if len == 2
      return spc. spc. spc . spc . spc . g:vimBoxLinterErrorSymbol . spc
    endif
    " Both errors and warning. Errors and warnings must divide up space evenly.
    if len == 3
      return g:vimBoxLinterErrorSymbol . spc
    endif
    return ''
  endfunction

  function! GetSyntasticWarnings()
    let spc = g:airline_symbols.space
    let g:syntastic_stl_format = '%W{ }%E{  }'
    let errors = SyntasticStatuslineFlag()
    let len = strlen(errors)
    " No errors no warning. syntasticOk will take up all the space
    if len == 0
      return ''
    endif
    " This must be a warning. Warning will take up all the space.
    if len == 1
      return spc. spc. spc . spc . spc . g:vimBoxLinterWarningSymbol . spc
    endif
    " Only errors, no warnings.
    if len == 2
      return ''
    endif
    " Both errors and warning. Errors and warnings must divide up space evenly.
    if len == 3
      return g:vimBoxLinterWarningSymbol . spc
    endif
    return ''
  endfunction

  function! GetSyntasticOk()
    let spc = g:airline_symbols.space
    let g:syntastic_stl_format = '%W{ }%E{  }'
    let errors = SyntasticStatuslineFlag()
    let len = strlen(errors)
    " No errors no warning. syntasticOk will take up all the space
    if len == 0
      return spc . spc . spc . spc . spc . spc . spc . spc . g:vimBoxLinterOkSymbol . spc
    endif
    " This must be a warning. Warning will take up all the space.
    if len == 1
      return ''
    endif
    " Only errors, no warnings.
    if len == 2
      return ''
    endif
    " Both errors and warning. Errors and warnings must divide up space evenly.
    if len == 3
      return ''
    endif
    return ''
  endfunction

  call airline#parts#define_function('syntasticErrors', 'GetSyntasticErrors')
  call airline#parts#define_function('syntasticWarnings', 'GetSyntasticWarnings')
  call airline#parts#define_function('syntasticOk', 'GetSyntasticOk')
  call airline#parts#define_minwidth('syntasticErrors', 30)
  call airline#parts#define_minwidth('syntasticWarnings', 30)
  " Might need to define a condition here?
  call airline#parts#define_minwidth('syntasticOk', 30)
  " let g:airline_section_warning=airline#section#create(['whitespace', 'syntasticWarnings'])
  let g:airline_section_warning=airline#section#create(['syntasticWarnings'])
  let g:airline_section_error=airline#section#create(['syntasticErrors'])
  " create doesn't add in between separators - unlike create_right'
  let g:airline_section_z=airline#section#create(['%3p%%'. g:airline_symbols.space, 'linenr',  ':%3v', 'syntasticOk'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

if has("gui_macvim") || has("gui_vimr")
  autocmd VimEnter * set guioptions+=e
endif
