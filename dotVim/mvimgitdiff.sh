#! /bin/bash
# see http://jeetworks.org/node/90
if [[ -f /Applications/MacVim.app/Contents/MacOS/Vim ]]
then
    # bypass mvim for speed
    VIMPATH='/Applications/MacVim.app/Contents/MacOS/Vim -g -O -f --nomru'
elif [[ -f /usr/local/bin/mvim ]]
then
    # fall back to mvim
    VIMPATH='mvim -d -f --nomru'
else
    # fall back to original vim
    VIMPATH='vimdiff'
fi

$VIMPATH '+windo set diff scrollbind scrollopt+=hor nowrap' -c 'au VimLeave * !open -a iTerm' $@

