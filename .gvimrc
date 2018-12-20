

" `before/after` Pattern inspired by Janus/spf-13
if filereadable(expand("~/.vim/gvimrc.custom.before"))
  source ~/.vim/gvimrc.custom.before
endif

if has('gui')
  if has("gui_macvim")

    " xxxxxx Required for Closer.vim()
    " Found a better way that doesnt require mapping this!
    " " macmenu &File.Close key=<nop>

    " Before:
    "  New Tab: CMD-t
    "  New Window: CMD-N
    "  Open Tab: CMD-T
    "  Show Errors: CMD-l
    " After:
    "  New Tab: CMD-n
    "  New Window: CMD-N
    "  Open Tab: No such thing
    "  Show Errors: unmapped
    macmenu &File.New\ Window key=<nop>
    macmenu &File.New\ Tab key=<nop>
    macmenu &File.New\ Tab key=<D-n>
    macmenu &File.New\ Window key=<D-N>
    macmenu &Tools.List\ Errors key=<nop>

    " Clear this up for something like CMD+t
    macmenu &File.Open\ Tab\.\.\. key=<nop>

    macmenu Window.Toggle\ Full\ Screen\ Mode key=<D-c-f>
    macmenu &Tools.Make key=<nop>


    " From subvim:
    " Disable print shortcut for 'goto anything...'
    macmenu File.Print key=<nop>

    " From subvim: Why do this again? Why not just swap like I've done?
    " create a new menu item with title "New File" and bind it to cmd+n 
    " new files will be created on a new tab
    " an 10.190 File.New\ File <nop>
    " macmenu File.New\ File action=addNewTab: key=<D-n>

  endif
endif

" `before/after` Pattern inspired by Janus/spf-13
if filereadable(expand("~/.vim/gvimrc.custom.after"))
  source ~/.vim/gvimrc.custom.after
endif

set visualbell
set t_vb=
