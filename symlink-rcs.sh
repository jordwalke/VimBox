#!/usr/bin/env bash

PWD=$(pwd)

if [[ ! -d "$HOME/.vim" && ! -L "$HOME/.vim" ]]; then
  echo -e "Moving $PWD/VimBox/dotVim to ~/.vim"
  ln -s "$PWD/VimBox/dotVim" ~/.vim
else
  echo -e "$HOME/.vim was already moved, or already exists"
fi

if [[ ! -f "$HOME/.vimrc" && ! -L "$HOME/.vimrc" ]]; then
  echo -e "Moving $PWD/VimBox/dotVimRc to ~/.vimrc"
  ln -s "$PWD/VimBox/dotVim" ~/.vimrc
else
  echo -e "$HOME/.vimrc was already moved, or already exists"
fi

if [[ ! -f "$HOME/.gvimrc" && ! -L "$HOME/.gvimrc" ]]; then
  echo -e "Moving $PWD/VimBox/dotGVimRc to ~/.gvimrc"
  ln -s "$PWD/VimBox/dotVim" ~/.gvimrc
else
  echo -e "$HOME/.gvimrc was already moved, or already exists"
fi
