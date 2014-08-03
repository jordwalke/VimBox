" File:        sessions.vim
" Version:     0.2
" Author:      Todd Boland <todd dot boland at charged software dot com>
" Description: Easy session management for gvim.
" Instructions:Put into ~/.vim/plugin/ and reload vim. Manage sessions
"              using new "Sessions" menu. You can put your existing session 
"              files in ~/.vim/sessions/ and :call DrawSessionMenu().
" History:     0.2 - Win32 support added.
"              0.1 - Initial Release.

" Based on http://www.vim.org/scripts/script.php?script_id=2151
" Modified by jordwalke to correctly detect .vim folder and a couple of other
" changes.

" Close enough:
if has('win32') || has ('win64')
    let s:vimHome = $VIM."/vimfiles"
else
    let s:vimHome = $HOME."/.vim"
endif

if exists('g:session_directory')
  let s:sessionDir = expand(g:session_directory)
else
  let s:sessionDir = s:vimHome . '/sessions'
endif

" Create vim home if needed
if !isdirectory(s:vimHome)
	call mkdir(s:vimHome)
endif

" Create sessions directory if needed
if !isdirectory(s:sessionDir)
	call mkdir(s:sessionDir)
endif

function! SaveSession()

	" If there isn't a current session, ask for a filename
	exec v:this_session != "" ? 
		\":mks! ".escape(v:this_session,' ') : ":browse mks ".s:sessionDir."<CR>"
	call DrawSessionMenu()
endfunction

" It has it's own function to call DrawSessionMenu() afterwards
function! SaveSessionAs()
	exec "browse mks ".s:sessionDir."<CR>"
	call DrawSessionMenu()
endfunction

function! DrawSessionMenu()

	" Unset the menu
	silent! aunmenu Sessions

	" Fetch session files
	let files = split(globpath(s:sessionDir, '/*.vim'), '\n')
	if len(files) > 0
		for file in files
			if filereadable(file)
        " Remove some mysterious double slashes
        let fullFile = substitute(file, "\/\/", "\/", "g")
        let filename = substitute(fullFile,".*\\/","","")
        let filebasename = substitute(filename,"\.vim","","")
        if (filename != "default.vim")
          if !filereadable(file . ".lock")
            " Extract filename
              exec "55amenu Sessions.".escape(filebasename,". ")." :OpenSession ".filebasename."<CR>"
          else
              let annotation = v:this_session == fullFile ? "\\ [Current] " : "\\ [Locked] "
              exec "55amenu Sessions.".escape(filebasename,". ").annotation. " :OpenSession ".filebasename."<CR>"
          endif
        endif
			endif
		endfor
		exec "55amenu Sessions.-Sep1- :<CR>"
	endif

	" Build rest of menu (TODO don't just mksession/source - use SaveSession " OpenSession)
	exec "55amenu Sessions.Save\\ Session\\ As\\ \\.\\.\\. :SaveSession "
	exec "55amenu Sessions.Open\\ Session\\ \\.\\.\\. :OpenSession "
	exec "55amenu Sessions.-Sep2- :<CR>"
	exec "55amenu Sessions.(default)\\ Save\\ Default\\ Session :SaveSession default<CR>"
	exec "55amenu Sessions.(default)\\ Open\\ Default\\ Session :OpenSession default<CR>"
	exec "55amenu Sessions.-Sep3- :<CR>"
	exec "55amenu Sessions.Restart\\ Vim\\ With\\ Current\\ Session :RestartVim<CR>"
endfunction

autocmd BufWinEnter * call DrawSessionMenu()

call DrawSessionMenu()
