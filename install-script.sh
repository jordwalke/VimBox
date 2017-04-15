#!/usr/bin/env bash

PWD=$(pwd)

if [[ -f "$PWD/dotVimRc" && ! -L "$PWD/dotVimRc" ]]; then
  # first, backup any existing scripts if they are not symlinks
  if [[ -d "$HOME/.vim" && ! -L "$HOME/.vim" ]]; then
    echo -e "Moving ~/.vim to ~/.vim_backup"
    mv ~/.vim ~/.vim_backup
  else
    echo "Not backing up $HOME/.vim - it has already been moved, is a symlink, or does not exist"
  fi

  # This is where neovim likes its config to be stored.
  # Inside of our .vim directory, we already have a sym link from init.vim to
  # .vimrc, so all we have to do is setup the directory for neovim.
  mkdir -p "$HOME/.config"
  if [[ -d "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
    echo -e "Moving ~/.config/nvim to ~/.config/nvim_backup"
    mv ~/.config/nvim ~/.config/nvim_backup
  else
    echo "Not backing up $HOME/.config/nvim - it has already been moved, is a symlink, or does not exist"
  fi

  # .vimrc is a file, use the -f flag
  if [[ -f "$HOME/.vimrc" && ! -L "$HOME/.vimrc" ]]; then
    echo -e "Moving $HOME/.vimrc to $HOME/.vimrc_backup"
    mv ~/.vimrc ~/.vimrc_backup
  else
    echo "Not backing up $HOME/.vimrc - it has already been moved, is a symlink, or does not exist"
  fi

  # .gvimrc is a file, use the -f flag
  if [[ -f "$HOME/.gvimrc" && ! -L "$HOME/.gvimrc" ]]; then
    echo -e "Moving $HOME/.gvimrc to $HOME/.gvimrc_backup"
    mv ~/.gvimrc ~/.gvimrc_backup
  else
    echo "Not backing up $HOME/.gvimrc - it has already been moved, is a symlink, or does not exist"
  fi

  # now we can link all the new VimBox to our home directory
  if [[ ! -d "$HOME/.vim" && ! -L "$HOME/.vim" ]]; then
    echo -e "Linking $HOME/.vim to $PWD/dotVim"
    ln -s "$PWD/dotVim" ~/.vim
  else
    echo -e "Not linking from $HOME/.vim - it was already moved, or already existed"
  fi

  if [[ ! -d "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
    echo -e "Linking $HOME/.config/nvim to $PWD/dotVim"
    ln -s "$PWD/dotVim" "$HOME/.config/nvim"
  else
    echo -e "Not linking from $HOME/.config/nvim - it was already moved, or already existed"
  fi

  if [[ ! -f "$HOME/.vimrc" && ! -L "$HOME/.vimrc" ]]; then
    echo -e "Linking $HOME/.vimrc to $PWD/dotVimRc"
    ln -s "$PWD/dotVimRc" ~/.vimrc
  else
    echo -e "Not linking from $HOME/.vimrc - it was already moved, or already existed"
  fi

  if [[ ! -f "$HOME/.gvimrc" && ! -L "$HOME/.gvimrc" ]]; then
    echo -e "Moving $PWD/dotGVimRc to ~/.gvimrc"
    ln -s "$PWD/dotGVimRc" ~/.gvimrc
  else
    echo -e "Not linking from $HOME/.gvimrc - it was already moved, or already existed"
  fi

  FONT_SOURCE="$PWD/dotVim/Fonts/Iosevka/iosevka-regular.ttf"
  FONT_DEST="$HOME/Library/Fonts/iosevka-regular.ttf"
  if [[ ! -f "$FONT_DEST" ]]; then
    echo -e "Installing font $FONT_SOURCE into $FONT_DEST"
    cp "$FONT_SOURCE" "$FONT_DEST"
  else
    echo -e "The font $FONT_DEST was already installed"
  fi
  FONT_SOURCE="$PWD/dotVim/Fonts/Iosevka/iosevka-bold.ttf"
  FONT_DEST="$HOME/Library/Fonts/iosevka-bold.ttf"
  if [[ ! -f "$FONT_DEST" ]]; then
    echo -e "Installing font $FONT_SOURCE into $FONT_DEST"
    cp "$FONT_SOURCE" "$FONT_DEST"
  else
    echo -e "The font $FONT_DEST was already installed"
  fi
  FONT_SOURCE="$PWD/dotVim/Fonts/Iosevka/iosevka-italic.ttf"
  FONT_DEST="$HOME/Library/Fonts/iosevka-italic.ttf"
  if [[ ! -f "$FONT_DEST" ]]; then
    echo -e "Installing font $FONT_SOURCE into $FONT_DEST"
    cp "$FONT_SOURCE" "$FONT_DEST"
  else
    echo -e "The font $FONT_DEST was already installed"
  fi
else
  echo -e "It seems you are not running the installer from within the VimBox root"
  exit 1
fi

