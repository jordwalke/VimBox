" Opens the console
if (!exists(":Console"))
  command! -nargs=* Console call console#Console()
endif
if (!exists(":Error"))
  command! -nargs=* Error call console#Error(<q-args>)
endif
if (!exists(":Info"))
  command! -nargs=* Info call console#Info(<q-args>)
endif
if (!exists(":Warn"))
  command! -nargs=* Warn call console#Warn(<q-args>)
endif

" let g:console_message_token_format=[]

" let g:console_message_token_hl=[]

