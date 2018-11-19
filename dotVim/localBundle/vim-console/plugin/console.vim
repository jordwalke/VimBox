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

" let g:console_message_token_format=[]

" let g:console_message_token_hl=[]

