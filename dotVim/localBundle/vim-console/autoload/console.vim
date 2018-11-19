let s:INFO_IDX=0
let s:SUCCESS_IDX=1
let s:WARN_IDX=2
let s:ERROR_IDX=3

" Findings:
" - It's impossible to get a straight bgcolor highlighting the entire
" command line. You can get most of the way there but it will cut off at about
" 8 characters towards the end. I tried to create my own padding exactly the
" width of the screen but it doesn't work, it's always off by eight.
" - shormess+=T only works with echomsg, and only with exe "norm :"
" - I figured out a way to highlight just the leading token and that solution
"   is the basis for the message format in this feature. You have to use
"   echomsg to make sure truncation works, but then you have to use echon with
"   a leading backslash-r to reset the drawing to the beginning of the line,
"   and then you can echohl to change the background color of the leading
"   token. But even then, you have to be careful to reset the hl to None. It
"   has to be done silenetly and on a following command.
"
" Also see this, which might enable showing something in the statusline.
" https://vi.stackexchange.com/questions/3352/is-it-possible-to-change-the-message-display-location
" TODO: Share this logic with VimBox.

" http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
function! console#doesNotStartWithToken(line)
  let escLogTokens = console#GetEscLogTokens()
  return match(a:line, escLogTokens[s:INFO_IDX]) != 0 &&
        \ match(a:line, escLogTokens[s:SUCCESS_IDX]) != 0 &&
        \ match(a:line, escLogTokens[s:WARN_IDX]) != 0 &&
        \ match(a:line, escLogTokens[s:ERROR_IDX]) != 0
endfunction


" Defaults if none specified.
" Info: Use for frequent opreations that hardly ever fail.
" Success: Use for important operations that might fail.
" Warning: Use for warnings
" Error: Use for errors
let s:console_message_token_format_pragmata_liga = ["[INFO]", "[INFO]", "[WARN]", "[ERR] "]
let s:console_message_token_format_standard = [" INFO   ", " SUCCESS", " WARNING", " ERROR  "]
let s:console_message_token_hl_airline = ["airline_a", "airline_a", "airline_warning", "airline_error"]
let s:console_message_token_hl_airline_bold = ["airline_a_bold", "airline_a_bold", "airline_warning_bold", "airline_error_bold"]
let s:console_message_token_hl_standard = ["WildMenu", "WildMenu", "Error", "Error" ]

function! console#GetLogTokens()
  if !exists('g:console_message_token_format')
    if console#HasPragmataProLigatures()
      return s:console_message_token_format_pragmata_liga
    else
      return s:console_message_token_format_standard
    endif
  else
    if len(g:console_message_token_format) < 4 || len(g:console_message_token_format) > 4
      echoerr "Error: Your g:console_message_token_format needs to have exactly four items"
      return s:console_message_token_format_standard
    endif
    return g:console_message_token_format
  endif
endfunction

function! console#GetEscLogTokens()
  let tokens = console#GetLogTokens()
  return [escape(tokens[s:INFO_IDX], "[]+."), escape(tokens[s:SUCCESS_IDX], "[]+."), escape(tokens[s:WARN_IDX], "[]+."), escape(tokens[s:ERROR_IDX], "[]+.")]
endfunction

function! console#GetLogHls()
  if !exists('g:console_message_token_hl')
    if exists("*airline#check_mode")
      " Ligatures don't render in bold for some reason.
      if console#HasPragmataProLigatures()
        return s:console_message_token_hl_airline
      else
        return s:console_message_token_hl_airline_bold
      endif
    else
      return s:console_message_token_hl_standard
    endif
  else
    if len(g:console_message_token_hl) < 4 || len(g:console_message_token_hl) > 4
      echoerr "Error: Your g:console_message_token_hl needs to have exactly four items"
      return s:console_message_token_hl_standard
    endif
    return g:console_message_token_hl
  endif
endfunction

let g:consoleMessageTimer = 0

function! console#foldExpr(line)
  return match(a:line,'Error')!=0 && match(a:line,'W[0-9]')!=0 && match(a:line,'E[0-9]')!=0 && console#doesNotStartWithToken(a:line)
endfunction

" The function definition must not be in a script or function which is called
" from an autocommand which is triggered by opening a file for editing.
" http://vim.1045645.n5.nabble.com/How-do-one-open-files-for-editing-from-a-function-td1153531.html
" (jordwalke: I bet that is so that opening files remains fast.)
" lsakd jflsakd flaks jfdlksa jdlfa
function! console#Console()
  let winnr = bufwinnr('^VimBoxConsole$')
  if winnr < 0
    let escLogTokens = console#GetEscLogTokens()
    silent! execute 'botright vnew VimBoxConsole'
    if exists('b:didSetupThisConsoleYet') && b:didSetupThisConsoleYet
      " Even if we didn't find it with bufwinnr, it existed and something
      " revived the console buffer into the window, and it's already prepared.
      " vnew ended up jumping us into that existing buffer.
      return
    endif
    let b:didSetSignsYet = 0
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap
    setlocal signcolumn=no
    setlocal foldminlines=1
    setlocal foldmethod=expr
    set foldexpr=v:lnum>5\ &&\ console#foldExpr(getline(v:lnum))
    sign define ConsoleTitle linehl=CursorLine
    execute 'syn match VimBoxConsoleInfo "^' . escLogTokens[s:INFO_IDX] . ' "'
    execute 'hi link VimBoxConsoleInfo ' . console#GetLogHls()[s:INFO_IDX]
    execute 'syn match VimBoxConsoleSuccess "^' . escLogTokens[s:SUCCESS_IDX] . ' "'
    execute 'hi link VimBoxConsoleSuccess ' . console#GetLogHls()[s:SUCCESS_IDX]
    execute 'syn match VimBoxConsoleWarn "^' . escLogTokens[s:WARN_IDX] . ' "'
    execute 'hi link VimBoxConsoleWarn ' . console#GetLogHls()[s:WARN_IDX]
    execute 'syn match VimBoxConsoleError "^' . escLogTokens[s:ERROR_IDX] . ' "'
    execute 'hi link VimBoxConsoleError ' . console#GetLogHls()[s:ERROR_IDX]
    silent! execute 'resize '
    silent! redraw
    setlocal foldenable
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'au BufLeave <buffer> execute "call console#StopMessagesTimer()"'
    silent! execute 'au BufEnter <buffer> execute "call console#ReloadMessagesWhileFocused(0)"'
    silent! execute 'au BufEnter <buffer> execute "call console#StartMessagesTimer()"'
    silent! execute 'au VimResized <buffer> execute "call console#Resized()"'
    silent! execute 'au WinEnter <buffer> execute "call console#Resized()"'
    silent! execute 'au WinLeave <buffer> execute "call console#Resized()"'
    call console#ReloadMessagesWhileFocused(1)
    call console#StartMessagesTimer()
    let b:didSetupThisConsoleYet = 1
  else
    silent! execute winnr . 'wincmd w'
  endif
endfun

function! console#IsLogWorthy(line)
  return a:line != 'Already at newest change'
        \ && !empty(trim(a:line))
        \ && match(a:line, '[0-9]\+ line less') != 0
        \ && match(a:line, 'search hit BOTTOM') != 0
        \ && match(a:line, 'search hit TOP') != 0
        \ && match(a:line, 'E486: Pattern not found:') != 0
        \ && match(a:line, '[0-9]\+ changes;') != 0
        \ && match(a:line, '[0-9]\+ fewer lines;') != 0
        \ && match(a:line, '[0-9]\+ more lines;') != 0
        \ && match(a:line, 'E[0-9]\+: No write since last change') != 0
        \ && match(a:line, '1 change;') != 0
        \ && match(a:line, '1 more line;') != 0
        \ && match(a:line, 'Type  :qa!  and press') != 0
endfunction

function! console#normalizeLine(line)
  if console#doesNotStartWithToken(a:line)
    if match(a:line, "Error ") == 0
      let logTokens = console#GetLogTokens()
      return logTokens[s:ERROR_IDX] . '  ' . a:line
    else
      if match(a:line, 'E[0-9]\+:') == 0
        let logTokens = console#GetLogTokens()
        return logTokens[s:ERROR_IDX] . '  ' . a:line
      else
        if match(a:line, 'W[0-9]\+:') == 0
          let logTokens = console#GetLogTokens()
          return logTokens[s:WARN_IDX] . '  ' . a:line
        else
          return a:line
        endif
      endif
    endif
  else
    return a:line
  endif
endfunction

function! console#ReloadMessagesWhileFocused(placeCursor)
  call console#Resized()
  let consoleTitle = ["", "", repeat(' ', winwidth('.') / 2) . "CONSOLE", "", "" ]
  setlocal noreadonly
  let logsWinNr = bufwinnr('^VimBoxConsole$')
  " This can happen when splitting the console window.
  " if winnr() != logsWinNr
  "   echoerr "Log window not set correctly"
  "   return
  " endif
  silent! execute  winnr < 0 ? 'botright vnew VimBoxConsole' : winnr . 'wincmd w'
  redir => l:messages
    silent messages
  redir end
  let curLines = getline(0, 9999)
  let newLines = filter(split(l:messages, "\n"), 'console#IsLogWorthy(v:val)')
  call extend(consoleTitle, newLines)
  let newLines = consoleTitle
  let newLen = len(newLines)
  let curLen = len(curLines)
  let i = 0
  let lastMeaningfulLine = 0
  while i < newLen
    let nextLine = console#normalizeLine(newLines[i])
    " > 5 check so we don't mess with the resizing console title.
    if (i < curLen && curLines[i] != nextLine && i > 5 || i >= curLen)
      if !console#foldExpr(nextLine)
        let lastMeaningfulLine = i
      endif
      silent! call setline(i + 1, nextLine)
    endif
    let i = i + 1
  endwhile
  while i < curLen
    silent! call setline(i + 1, '')
    let i = i + 1
  endwhile
  if a:placeCursor
    execute ":" . (lastMeaningfulLine + 1)
    " Make sure to focus past the highlighted [ERROR]:
    silent! norm ":W"
  endif
  if !b:didSetSignsYet
    silent! exe ":sign place 1 line=2 name=ConsoleTitle buffer=" . bufnr("VimBoxConsole")
    silent! exe ":sign place 2 line=3 name=ConsoleTitle buffer=" . bufnr("VimBoxConsole")
    silent! exe ":sign place 3 line=4 name=ConsoleTitle buffer=" . bufnr("VimBoxConsole")
    let b:didSetSignsYet=1
  endif
  setlocal readonly
endfun

function! console#StopMessagesTimer()
  call timer_stop(g:consoleMessageTimer)
  let g:consoleMessageTimer = 0
endfunction

let s:consoleTextLineNr = 3
function! console#Resized()
  setlocal noreadonly
  silent! call setline(s:consoleTextLineNr , repeat(' ', winwidth('.') / 2) . "CONSOLE")
  setlocal noreadonly
endfunction


function! console#StartMessagesTimer()
  let g:consoleMessageTimer = timer_start(1000, 'OnMessagesTimer',{'repeat':-1})
endfunction

function! OnMessagesTimer(timer)
  let winnr = bufwinnr('^VimBoxConsole$')
  " This can happen when splitting the console
  " if winnr < 0 || winnr != winnr()
  "   echoer "stopping timer"
  "   call console#StopMessagesTimer()
  " else
  "   call console#ReloadMessagesWhileFocused(0)
  " endif
  call console#ReloadMessagesWhileFocused(0)
endfunction

function! console#ShortHl(prefix, hl, msg)
  " If performing our own shortening for the sake of creating a colored bar at
  " the bottom, then we actually _have_ to disable T.
  let saved=&shortmess
  set shortmess+=T
  let typ1 = type(a:msg)
  let msg = a:msg
  if typ1 != v:t_string
    let msg = string(msg)
  endif
  let cols = &columns
  let msgNotif =  a:prefix . '  ' . msg
  let prefix = "\r" . a:prefix . ' '
  " :echohl ErrorMsg | echo "Don't panic!" | echohl None
  " If you break out of the string to concatenate the expression msgNotif it
  " ruins the shortmess! But you don't need to! exe does something magical and
  " escapes the strings automatically wat.
  "
  " Not needed, and actually harmful:
  "
  "    let msgNotif = escape(msgNotif, '"')
  "
  " This doesn't work, we have to silently reset the none, otherwise it
  " destroys +=T
  " exe "norm :echomsg msgNotif | echohl airline_error | echon prefix | echohl None\n"
  " echohl airline_error
  exe "norm :echomsg msgNotif | echohl " . a:hl . " | echon prefix\n"
  silent echohl None
  let &shortmess=saved
  " If the log file is opened just refresh it right now.
  let logWinNr = bufwinnr('^VimBoxConsole$')
  if (logWinNr >= 0 && winnr() == logWinNr)
    call console#ReloadMessagesWhileFocused(0)
  endif
endfunction

" Detect if the user is viewing with token ligatures for [ERROR] etc.  Add
" logic for any custom fonts. Will not return true when starting up a GUI,
" before the GUI font is set by the user's config.
function! console#HasPragmataProLigatures()
  let guifont = &guifont
  let hasGuiWithLiga = (has('gui') && has('mac') && &macligatures) || has('gui')
  let hasPragmataGui = hasGuiWithLiga && (match(guifont, 'Pragmata') != -1)
  if !hasPragmataGui
    return 0
  else
    "Essentials don't have ligatures.
    if (match(guifont, 'Essential') != -1)
      return 0
    else
      if (match(guifont, 'Mono') != -1) && (match(guifont, 'Liga') == -1)
        return 0
      else
        return 1
      endif
    endif
  endif
endfunction

function! console#Info(msg)
  if exists('g:vimBoxIsLoading') && g:vimBoxIsLoading
    call extend(g:vimBoxInfosDuringLoad, [a:msg])
    return
  endif
  call console#ShortHl(console#GetLogTokens()[s:INFO_IDX], console#GetLogHls()[s:INFO_IDX], a:msg)
endfunction

function! console#Success(msg)
  if exists('g:vimBoxIsLoading') && g:vimBoxIsLoading
    call extend(g:vimBoxSuccessesDuringLoad, [a:msg])
    return
  endif
  call console#ShortHl(console#GetLogTokens()[s:SUCCESS_IDX], console#GetLogHls()[s:SUCCESS_IDX], a:msg)
endfunction

function! console#Warn(msg)
  if exists('g:vimBoxIsLoading') && g:vimBoxIsLoading
    call extend(g:vimBoxWarningsDuringLoad, [a:msg])
    return
  endif
  call console#ShortHl(console#GetLogTokens()[s:WARN_IDX], console#GetLogHls()[s:WARN_IDX], a:msg)
endfunction

function! console#Error(msg)
  if exists('g:vimBoxIsLoading') && g:vimBoxIsLoading
    call extend(g:vimBoxErrorsDuringLoad, [a:msg])
    return
  endif
  call console#ShortHl(console#GetLogTokens()[s:ERROR_IDX], console#GetLogHls()[s:ERROR_IDX], a:msg)
endfunction

" Command form which evals its arguments as a string and gracefully fails,
" printing a nice error message instead of an obtrusive Press-Enter box.
function! console#InfoCmd(msg)
  let errorEvaling = 0
  try
    let result = eval(a:msg)
  catch /.*/
    let result = v:exception
    let errorEvaling = 1
  finally
    if errorEvaling
      call console#Error("Error running expression(" . a:msg . ") - " . result  . " - See :Console")
    else
      call console#Info(result)
    endif
  endtry
endfunction


function! console#SuccessCmd(msg)
  let errorEvaling = 0
  try
    let result = eval(a:msg)
  catch /.*/
    let result = v:exception
    let errorEvaling = 1
  finally
    if errorEvaling
      call console#Error("Error running expression(" . a:msg . ") - " . result  . " - See :Console")
    else
      call console#Success(result)
    endif
  endtry
endfunction

function! console#WarnCmd(msg)
  let errorEvaling = 0
  try
    let result = eval(a:msg)
  catch /.*/
    let result = v:exception
    let errorEvaling = 1
  finally
    if errorEvaling
      call console#Error("Error running expression(" . a:msg . ") - " . result  . " - See :Console")
    else
      call console#Warn(result)
    endif
  endtry
endfunction

function! console#ErrorCmd(msg)
  let errorEvaling = 0
  try
    let result = eval(a:msg)
  catch /.*/
    let result = v:exception
    let errorEvaling = 1
  finally
    if errorEvaling
      call console#Error("Error running expression(" . a:msg . ") - " . result  . " - See :Console")
    else
      call console#Error(result)
    endif
  endtry
endfunction

