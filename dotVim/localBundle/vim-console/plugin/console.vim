" Opens the console
if (!exists(":Console"))
  command! -complete=expression -nargs=* Console call console#Console()
endif
if (!exists(":Error"))
  command! -complete=expression -nargs=* Error call console#ErrorCmd(<q-args>)
endif
if (!exists(":Info"))
  command! -complete=expression -nargs=* Info call console#InfoCmd(<q-args>)
endif
" Log will just be Info: TODO: Make this a different entry that doesn't output
" anything and doesn't clear the command output.
if (!exists(":Log"))
  command! -complete=expression -nargs=* Log call console#InfoCmd(<q-args>)
endif
if (!exists(":Success"))
  command! -complete=expression -nargs=* Success call console#SuccessCmd(<q-args>)
endif
if (!exists(":Warn"))
  command! -complete=expression -nargs=* Warn call console#WarnCmd(<q-args>)
endif


" Vim frowns up on this, so we make it disable-able, but for something you
" probably want to use so often, I think this is justified.
if exists('g:console_nolowercase') && !g:console_nolowercase
else
  cnoreabbrev console Console
  cnoreabbrev error Error
  cnoreabbrev warn Warn
  cnoreabbrev info Info
  cnoreabbrev log Log
  cnoreabbrev success Success
endif


" Standard Polyfill
" The v:t_number form was only recently added in Vim. This is a universal
" polyfill you can put in any plugin (multiple times without harm)
" There is no false/true/none/null for older vim versions.  If you know you
" are on vim-8, then I don't know why you'd need these g: variables you could
" just use v:t_boolean, but at least this way it's consistent.' There's
" probably some earlier 7.x version/patch that would be a better check.'
" Interesting: v:none==0 and v:null==0 but v:none != v:null and type(v:none)
" != type(0) and type(v:null) != type(0) This gives you a way to distinguish 0
" from none/null and none from null.
if !exists('g:polyfilled_v_type')
  let g:polyfilled_v_type=1
  let g:v_t_number = type(0)
  let g:v_t_string = type("")
  let g:v_t_func = type(function("tr")) 
  let g:v_t_list = type([]) 
  let g:v_t_dict = type({}) 
  let g:v_t_float = type(0.0) 
  if has("patch-8.0.0")
    let g:v_t_bool = type(v:false) 
    let g:v_t_none = type(v:none) 
  endif
endif


" let g:console_message_token_format=[]

" let g:console_message_token_hl=[]

