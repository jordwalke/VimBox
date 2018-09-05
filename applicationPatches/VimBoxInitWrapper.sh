#!/bin/bash
#
# This shell script passes all its arguments to the binary inside the
# MacVim.app application bundle.  If you make links to this script as view,
# gvim, etc., then it will peek at the name used to call it and set options
# appropriately.
#
# Based on a script by Wout Mertens and suggestions from Laurent Bihanic.  This
# version is the fault of Benji Fisher, 16 May 2005 (with modifications by Nico
# Weber and Bjorn Winckler, Aug 13 2007).
# First, check "All the Usual Suspects" for the location of the Vim.app bundle.
# You can short-circuit this by setting the VIM_APP_DIR environment variable
# or by un-commenting and editing the following line:
# VIM_APP_DIR=/Applications

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"

binary="${DIR}/VimOrig"
# export MYVIMRC="${VIM_APP_DIR}/dotVimRc"
# MYGVIMRC IS NOT RESPECTED!
# Have to use unix files https://stackoverflow.com/a/4618219
# export MYGVIMRC="${VIM_APP_DIR}/dotGVimRc"
export VIMBOX_OVERRIDING_INIT=1
exec "$binary" -u "${DIR}/../../../VimBoxCheckout/dotVimRc" -U "${DIR}/../../../VimBoxCheckout/dotGVimRc" "$@"
