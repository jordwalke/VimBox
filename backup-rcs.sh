#!/usr/bin/env bash

# No trailing slashes to preserve symlinks!
if [ -d "~/.vim" ]; then
  echo -e "moving ~/.vim to ~/.vim_backup"
  mv ~/.vim ~/.vim_backup
else
  echo "~/.vim has already been moved or does not exist"
fi

if [ -d "~/.vimrc" ]; then
  echo -e "moving ~/.vimrc to ~/.vimrc_backup"
  mv ~/.vimrc ~/.vimrc_backup
else
  echo "~/.vimrc has already been moved or does not exist"
fi

if [ -d "~/.gvimrc" ]; then
  echo -e "moving ~/.gvimrc to ~/.gvimrc_backup"
  mv ~/.gvimrc ~/.gvimrc_backup
else
  echo "~/.gvimrc has already been moved or does not exist"
fi