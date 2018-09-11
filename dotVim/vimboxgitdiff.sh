#! /bin/bash
# see http://jeetworks.org/node/90
if [[ -f /Applications/VimBox.app/Contents/Resources/VimBoxCheckout/applicationPatches/box ]]
then
    # bypass box for speed
    VIMPATH='/Applications/VimBox.app/Contents/Resources/VimBoxCheckout/applicationPatches/box -d -g -O -f --nomru'
else
    # fall back to original vim
    VIMPATH='vimdiff'
fi

if [ "$TERM_PROGRAM" = "Apple_Terminal" ];
then
  $VIMPATH '+windo set diff scrollbind scrollopt+=hor nowrap' -c 'au VimLeave * !open -a Terminal' $@
elif [ "$TERM_PROGRAM" = "iTerm.app" ];
then
  $VIMPATH '+windo set diff scrollbind scrollopt+=hor nowrap' -c 'au VimLeave * !open -a iTerm' $@
elif [ "$TERM_PROGRAM" = "Hyper" ];
then
  $VIMPATH '+windo set diff scrollbind scrollopt+=hor nowrap' -c 'au VimLeave * !open -a Hyper' $@
else
  $VIMPATH '+windo set diff scrollbind scrollopt+=hor nowrap' $@
fi

