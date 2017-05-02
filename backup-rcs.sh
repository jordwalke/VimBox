#!/usr/bin/env bash

# No trailing slashes to preserve symlinks!
if [ -d "$HOME/.vim" && ! -L "$HOME/.vim" ]; then
  echo -e "moving ~/.vim to ~/.vim_backup"
  mv ~/.vim ~/.vim_backup
else
  echo "$HOME/.vim has already been moved, is a symlink, or does not exist"
fi

if [ -f "$HOME/.vimrc" && ! -L "$HOME/.vimrc" ]; then
  echo -e "moving ~/.vimrc to ~/.vimrc_backup"
  mv ~/.vimrc ~/.vimrc_backup
else
  echo "$HOME/.vimrc has already been moved, is a symlink, or does not exist"
fi

if [ -f "$HOME/.gvimrc" && ! -L "$HOME/.gvimrc" ]; then
  echo -e "moving ~/.gvimrc to ~/.gvimrc_backup"
  mv ~/.gvimrc ~/.gvimrc_backup
else
  echo "$HOME/.gvimrc has already been moved, is a symlink, or does not exist"
fi