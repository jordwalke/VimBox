# Locations:

This doc explains where various Vim installations install their system
vimrc files.

This is only important for plugin developers and contributors of VimBox.  It's
especially important when running Vim in "VimBox" mode which doesn't use your
fixed-location vimrc files (typically in ~/.vimrc) (VimBox doesn't step on or
use your typical vimrc file). For unnkown reasons, when you don't use the
normal vimrc files, and specify other ones to use (like VimBox does), the
default vimrc files don't load, so VimBox has to manually load them.


## VimBox.app (which passes -u -U arguments to load custom vimrc files):

**Output of `:version`:**

       system vimrc file: "$VIM/vimrc"
         user vimrc file: "$HOME/.vimrc"
     2nd user vimrc file: "~/.vim/vimrc"
          user exrc file: "$HOME/.exrc"
      system gvimrc file: "$VIM/gvimrc"
        user gvimrc file: "$HOME/.gvimrc"
    2nd user gvimrc file: "~/.vim/gvimrc"
           defaults file: "$VIMRUNTIME/defaults.vim"
        system menu file: "$VIMRUNTIME/menu.vim"       

**Variables set by Vim:**

    $VIM
    /Applications/VimBox.app/Contents/Resources/VimBox.app/Contents/Resources/vim/
      ├── runtime/
      ├── vimrc
      └── gvimrc

    $VIMRUNTIME
    /Applications/VimBox.app/Contents/Resources/VimBox.app/Contents/Resources/vim/runtime/


    $MYGVIMRC (empty)   # This was always empty
    $MYVIMRC  (empty)   # This becomes empty due to -u



## MacVim:

(Same as VimBox - except the following variables):

    $MYGVIMRC (empty)
    $MYVIMRC  ~/.vimrc
    


## OSX Vim (CLI)

**Output of `:version`:**

       system vimrc file: "$VIM/vimrc"
         user vimrc file: "$HOME/.vimrc"
     2nd user vimrc file: "~/.vim/vimrc"
          user exrc file: "$HOME/.exrc"
           defaults file: "$VIMRUNTIME/defaults.vim"
      fall-back for $VIM: "/usr/share/vim"
      

**Variables set by Vim:**

    $VIM
    /usr/share/vim/
    ├── vim80/
    └── vimrc

    $VIMRUNTIME
    /usr/share/vim/vim80


    $MYGVIMRC (empty)
    $MYVIMRC  ~/.vimrc



## VimBox.exe:

(Same as GVim.exe except `$MYVIMRC` is empty as it is with VimBox.app - any
time you set -u it clears this env var).



## GVim.exe: (Also true of command line vim.exe installed via GVim)

**Output of `:version`:**


       system vimrc file: "$VIM\vimrc"
         user vimrc file: "$HOME\_vimrc"
     2nd user vimrc file: "$HOME\vimfiles\vimrc"
     3rd user vimrc file: "$VIM\_vimrc"   # THIS IS THE ONLY ONE ACTUALLY THERE.
          user exrc file: "$HOME\_exrc"
      2nd user exrc file: "$VIM\_exrc"
      system gvimrc file: "$VIM\gvimrc"
        user gvimrc file: "$HOME\_gvimrc"
    2nd user gvimrc file: "$HOME\vimfiles\gvimrc"
    3rd user gvimrc file: "$VIM\_gvimrc"
           defaults file: "$VIMRUNTIME\defaults.vim"
        system menu file: "$VIMRUNTIME\menu.vim"   

**Variables set by Vim:**

    $VIM
    C:\Program\ Files(x86)\Vim\
    ├── vim81\
    │   └── mswin.vim
    │
    └── _vimrc  # Sources mswin.vim (that's like the default gvimrc)

    $VIMRUNTIME
    C:\Program\ Files(x86)\Vim\vim81\
    
    $MYGVIMRC (empty)
    $MYVIMRC: "$VIM\_vimrc"



## Vim Cygwin installed via Cmder.exe:

Seems to be broken as system vimrc isn't present.

**Output of `:version`:**

       system vimrc file: "/etc/vimrc"  # This didn't even exist in cmder.exe
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
       defaults file: "$VIMRUNTIME/defaults.vim"
  fall-back for $VIM: "/etc"
 f-b for $VIMRUNTIME: "/usr/share/vim/vim80"



## Vim Cygwin installed via Cygwin:

Seems to be broken as system vimrc isn't present.

**Output of `:version`:**

   system vimrc file: "/etc/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
       defaults file: "$VIMRUNTIME/defaults.vim"
  fall-back for $VIM: "/etc"
 f-b for $VIMRUNTIME: "/usr/share/vim/vim80"

