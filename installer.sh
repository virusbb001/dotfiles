#!/bin/sh

cd "$(dirname "$0")" || exit 1

if [ ! -f ~/.vimrc ]; then
 install -m 0644 home/dot_vimrc ~/.vimrc
else
 echo ".vimrc already exists. skip"
fi

if [ ! -f ~/.zshrc ]; then
 install -m 0644 home/dot_zshrc ~/.zshrc
else
 echo ".zshrc already exists. skip"
fi

if [ ! -f ~/.zshenv ]; then
 install -m 0644 home/dot_zshenv ~/.zshenv
else
 echo ".zshenv already exists. skip"
fi

if [ ! -f ~/.tmux.conf ]; then
 install -m 0644 home/dot_tmux_conf ~/.tmux.conf
else
 echo ".tmux.conf already exists. skip"
fi
