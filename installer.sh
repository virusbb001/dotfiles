#!/bin/bash

cd "$(dirname "$0")" || exit 1
DOTFILES_DIR="$(pwd)"
ORIG_UMASK=$(umask)

umask 022

# cp -nrv  ./* $HOME
files="$(ls -A home)"
for file in $files ; do
  if [ -f "$HOME/$file" ]; then
    echo "\$HOME/$file already exits. skip"
  else
    echo install -m 0644 "home/$file" "$HOME/$file"
    install -m 0644 "home/$file" "$HOME/$file"
  fi
done

umask "$ORIG_UMASK"

if ! (grep XDG_CONFIG_DIRS ~/.bashrc >/dev/null); then
  echo "export XDG_CONFIG_DIRS=\"$DOTFILES_DIR/config:\$XDG_CONFIG_DIRS\"" >> ~/.bashrc
  echo "added XDG_CONFIG_DIRS setting to bashrc"
fi

if ! (git config --global --get-all include.path | grep $DOTFILES_DIR/gitconfig); then
  git config --global --add include.path $DOTFILES_DIR/gitconfig
fi
