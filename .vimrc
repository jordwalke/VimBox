


" ================================================
"         .__           ___.
"  ___  __|__|  _____   \_ |__    ____  ___  ___
"  \  \/ /|  | /     \   | __ \  /  _ \ \  \/  /
"   \   / |  ||  Y Y  \  | \_\ \(  <_> ) >    <
"    \_/  |__||__|_|  /  |___  / \____/ /__/\_ \
"                   \/       \/               \/
" ================================================
"
"
" See `README.md` for features and shortcuts
" Additional features not mentioned in README:
"
" Spell Check:
" Command+shift+p to toggle spell check on comments (underlines in red).
"
" Mac ProTips:
"  To further improve the text rendering on Mac OSX:
"  1. From the shell: defaults write org.vim.MacVim MMCellWidthMultiplier 0.9
"  2. Opens all files from other apps in vert split defaults write
"  org.vim.MacVim MMVerticalSplit YES
"  3. If when changing monitors, your fonts go from nice and thin to ugly and
"  bold: This should fix it:
"   Textmate disables font smoothing only for dark backgrounds, but MacVim
"   only has a global setting. If you use dark backgrounds consider disabling.
"   https://stackoverflow.com/questions/24598390/macvim-thicker-font-rendering-compared-to-textmate
"   defaults write org.vim.MacVim AppleFontSmoothing -int 0  
"  4. Speed up full screen transition:
"  defaults write org.vim.MacVim MMFullScreenFadeTime 0.05
"
" Cygwin:
" Tested and should work. AutoHotkey exist that provide an identical experience
" to the Mac OSX experience.
"
" Bundle System:
" =================================================================
" Uses the VimPlug system. Add bundles to ~/.vim/bundlesVimRc with:
" Plug "githubUser/repo"
" Open a new window and then run `:PlugInstall`
" Close and then reopen the vim window.

" Performance Profiling:
" ========================
" http://stackoverflow.com/questions/12213597/how-to-see-which-plugins-are-making-vim-slow
"
" Find Slow Plugins During Actions:
" =================================
"
"   :profile start profile.log
"   :profile func *
"   :profile file *
"   " At this point do slow actions
"   :profile pause
"   :noautocmd qall!
"
" Profile Startup Time:
" ==================================================================
"   mvim --startuptime ~/.vim/timeCost.txt ~/.vim/timeCost.txt
"
" Debugging VimSript Errors:
" ==================================================================
" Ever have this happen to you?
"
"    Error <SNR>49_Destroy[10]...Line 3
"
" This is Vim's idea of a good error message (when one of your plugin throws
" an error). See that weird <SNR>49? That's the script number which is
" assigned to the VimScript file behind the scenes (invisibly to you) - Here's
" how you find out which script that is. Execute :scriptnames and find the
" corresponding number in that list.  So <SNR>49 means script number 49, and
" Destroy, UnsetIMap are the last two functions in the stack trace (so the
" problem is ultimately in UnsetIMap in my case).  And that "line 3"?  That's
" not the line number in the file like any reasonable error message would
" display that's the line number within the deepest function.

" Seeing Who Is Setting A Setting:
" =================================================================
" :verbose set settingName?

" Using In Terminal
" ================
" Using VimBox in your terminal is semi-supported. It should work, but it is
" not tested often. If you see something off, please report but a PR is
" the best way to move VimBox forward with terminal support.
"
" Note: If you use iTerm, and you want airline symbols to show up correctly
" you must change the font in *two* places in iTerm. The normal font, and the
" non-ascii font!
"
" Remote Editing:
"
" - Speed up performance at the network layer:
"   http://thomer.com/howtos/netrw_ssh.html
" - Help netrw-passwd
"
" - Also good suggestions here: https://stackoverflow.com/questions/28795721/how-to-save-in-vim-a-remote-file-asynchronously
"   - As always disable airline/lightline vcs integration.
" - https://github.com/eshion/vim-sync/
" - https://github.com/grantm/bcvi
" - https://github.com/seletskiy/vim-refugi

" if v:version < 799
  " echomsg "VimBox works best with Vim8 or newer. Please upgrade your Vim/MacVim"
" endif

if has('gui_win32')
  set rtp+=~/.vim
endif

if has('vim_starting')
   if &compatible
     set nocompatible               " Be iMproved
   endif
endif

silent! call plug#begin('~/.vim/bundle')

if filereadable(expand("~/.vim/vimrc.custom.before"))
  source ~/.vim/vimrc.custom.before
endif

set noswapfile     " Don't make backups.
set nowritebackup " Even if you did make a backup, don't keep it around.
set nobackup

syntax on
set virtualedit=block
set tabstop=2
set nonumber
set noswapfile

set mouse=a
set nospell
set ic
set scs

" TODO: Set up mappings to toggle between text mode and code mode.
" Editing code
set nowrap
set wrapmargin=0
" let &textwidth=exists('g:textColumns') && !empty(g:textColumns) ? g:textColumns : 80
set nolinebreak

set hlsearch
set formatoptions+=or

let &tabstop=exists('g:tabSize') ? g:tabSize : 2
let &softtabstop=exists('g:tabSize') ? g:tabSize : 2
let &shiftwidth=exists('g:tabSize') ? g:tabSize : 2
set expandtab
set ignorecase
set infercase
let g:omni_syntax_ignorecase=1
set wildmode=full
set wildignore+=*/node_modules/**
" Including this messes up fugitive in git mergetool:
" set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
set sm!  " show matching brace/paren

" Disable visualbell by default
" http://unix.stackexchange.com/a/5313
set visualbell
set t_vb=

" Should avoid "Hit Enter" annoyingness (Does *not* work)
" The final c gets rid of annoying autocomplete messages.
try
  set shortmess+=filmnrxoOtTc
catch /E539: Illegal character/
  " Some versions do not like c
  set shortmess+=filmnrxoOtT
endtry
" Disable Vim's startup screen
set shortmess+=I
" Customize:
" http://vi.stackexchange.com/questions/627/how-can-i-change-vims-start-or-intro-screen



" Mac Support bootstrap
set wildignore+=*.DS_Store
set wildignore+=*/_build**
set wildignore+=*/.ssh
set wildignore+=*/.yarn
set wildignore+=*/.npm
set wildignore+=*/.jenga

" Remove ugly folds
set nofoldenable
" nofoldenable doesn't work in diff mode so do something similar
set diffopt=filler,context:9999

" ============= Configure as Privacy Plugin =========================
" All sensitive data is not stored in your ~/.vimrc folder
" Configure the spelling language and file.
" ================================================================
set spelllang=en
set spellfile=$HOME/vim_spell/en.utf-8.add
" UndoDir:
let s:homeFolder = $HOME
if (exists('g:vimBoxUndoDir'))
  let s:undoDir = g:vimBoxUndoDir
else
  let s:undoDir = s:homeFolder . '/vimUndo'
endif
set undofile
" " Create undo dir if needed - not in your dotVim folder! It should be local to
" " your computer.
if !isdirectory(s:undoDir)
  call mkdir(s:undoDir)
endif
execute "set undodir=".s:undoDir
" Since your file/folder history may show up in a git commit!
let g:netrw_dirhistmax=0
" ================================================================

" =========================== FIX SHELL ==========================
if &shell =~# 'fish$'
    set shell=sh
endif
" ================================================================

" http://stackoverflow.com/questions/6852763/vim-quickfix-list-launch-files-in-new-tab
" This is respected by bnext/bprev/bfirst commands!
try
  set switchbuf+=useopen,usetab,vsplit
catch /E474: Invalid argument/
  set switchbuf+=useopen,usetab
endtry

" A better diff link for macvim
" alias mvimdiff="mvim -O  \"+windo set diff scrollbind scrollopt+=hor nowrap\""


" iTerm requires the following commented code to be placed in your .bashrc in
" order for Vim to show full 256 colors.
" export CLICOLOR=1
" export TERM='xterm-256color'
" if [ -e /usr/share/terminfo/x/xterm-256color ]; then
"   export TERM='xterm-256color'
" else
"   #export TERM='xterm-color'
"   export TERM=xterm-256color
" fi
" If your terminal does *not* support 256 color, if if you want better than
" 256, and are willing to limit to base16 colorschemes you enable this:
" (You probably also need the base16 colorscheme shell script to exist
" somewhere in your path) - See the base16 docs.
" let base16colorspace="256"
set t_Co=256

if (empty($TMUX))
  " ======================================================================
  " This doesn't actually work with vim-airline yet in the most recent
  " versions of Vim/NeoVim (except with MacVim strangely). See ~/.vim/neoVimRc
  " ======================================================================
  if (has("termguicolors"))
    " old airline doesn't render correctly without these two obscure settings.
    " New airline should work without them.
    " https://github.com/vim/vim/issues/993
    " set Vim-specific sequences for RGB colors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif
endif

if (has("nvim"))
  source ~/.vim/neoVimRc
endif

if exists('g:nyaovim_version')
  source ~/.vim/nyaoVimRc
endif

" Load all the bundles
source ~/.vim/bundlesVimRc
if filereadable(expand("~/.vim/bundlesVimRc.custom"))
  source ~/.vim/bundlesVimRc.custom
endif

call plug#end()

" MacVim Quick Start is pretty strange. It's as if it always opens the *next*
" MacVim window whenever you open the currently visible one.
" So this prompt applies to the *next* window you'll open typically - in that
" case.
" Notice the ! not
if !len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  " Everything's already installed. Configure the plugins
  source ~/.vim/guiSettingsVimRc
  source ~/.vim/keysVimRc
  source ~/.vim/customFunctions.vim
  " Some vim reset plugin screws up listchars
  set listchars = "eol:$"
  source ~/.vim/vimrc.custom.after
else
  " Don't show statusline when airline might not be loaded or configured.
  if exists("g:gui_oni") || has('gui') && has('mac') && has('gui_running')
    set background=dark
    colorscheme vimBoxColorsDuringLoad
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    " The backticks and echo make it work better in terminal env
    autocmd VimEnter *
      \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) && 1==confirm("Download and Install Plugins?", "&Yes\n&No", 1)
      \|   set laststatus=0
      \|   PlugInstall --sync | echomsg "Open a new window to enjoy the plugins!" | let xx=confirm("Open a New Window For Plugins to Take Effect.")
      \| endif
    " Source the settings just in case they respond with "No, don't update plugins"
    source ~/.vim/guiSettingsVimRc
    source ~/.vim/keysVimRc
    source ~/.vim/customFunctions.vim
    " Some vim reset plugin screws up listchars
    set listchars = "eol:$"
    " VimBox plugin configuration that has to be performed after loading
    " plugins.
    source ~/.vim/vimrc.custom.after
  else
    set laststatus=0
    echomsg "Attempting to install plugins. Be patient. Vim is working in the background. It will start eventually."
    PlugInstall --sync
    source ~/.vim/guiSettingsVimRc
    source ~/.vim/keysVimRc
    source ~/.vim/customFunctions.vim
    " Some vim reset plugin screws up listchars
    set listchars = "eol:$"
    " VimBox plugin configuration that has to be performed after loading
    " plugins.
    source ~/.vim/vimrc.custom.after
  endif
endif
