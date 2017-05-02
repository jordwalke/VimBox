#!/usr/bin/env bash

PWD=$(pwd)

if [[ ! -d "$HOME/.vim" && ! -L "$HOME/.vim" ]]; then
  echo -e "Moving $PWD/dotVim to ~/.vim"
  ln -s "$PWD/dotVim" ~/.vim
else
  echo -e "$HOME/.vim was already moved, or already exists"
fi

if [[ ! -f "$HOME/.vimrc" && ! -L "$HOME/.vimrc" ]]; then
  echo -e "Moving $PWD/dotVimRc to ~/.vimrc"
  ln -s "$PWD/dotVimRc" ~/.vimrc
else
  echo -e "$HOME/.vimrc was already moved, or already exists"
fi

if [[ ! -f "$HOME/.gvimrc" && ! -L "$HOME/.gvimrc" ]]; then
  echo -e "Moving $PWD/dotGVimRc to ~/.gvimrc"
  ln -s "$PWD/dotGVimRc" ~/.gvimrc
else
  echo -e "$HOME/.gvimrc was already moved, or already exists"
fi
