#!/bin/bash
# should run in nix-shell

cd "$(dirname "$0")" || exit 1
DOTFILES_DIR="$(pwd)"
ORIG_UMASK=$(umask)

umask 022

function check_file () {
  local filename="$1";

  if [ -e "$filename" ]; then
    return 0;
  else
    echo "${filename} already exists."
    return 1;
  fi
}

# cp -nrv  ./* $HOME
files="$(ls -A home)"
for file in $files ; do
  if [ -e "$HOME/$file" ]; then
    echo "\$HOME/$file already exists. skip"
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

if [ -e "$HOME/README.md" ]; then
  echo "\$HOME/README.md already exists. skip"
else
  ln -s $DOTFILES_DIR/memo/home.md $HOME/README.md
fi

if which nix >/dev/null ; then
  hmconfig="$HOME/.config/home-manager"
  nix_system=$(nix eval --impure --raw --expr 'builtins.currentSystem')
  if check_file "$hmconfig/home.nix"; then
    mo ./templates/home-manager/home.nix > "$hmconfig/home.nix"
  fi
  DOTFILES_DIR=$DOTFILES_DIR NIX_SYSTEM=$nix_system mo ./templates/home-manager/flake.nix
  if check_file "$hmconfig/flake.nix"; then
    DOTFILES_DIR=$DOTFILES_DIR NIX_SYSTEM=$nix_system mo ./templates/home-manager/flake.nix > "$hmconfig/flake.nix"
  fi
fi
