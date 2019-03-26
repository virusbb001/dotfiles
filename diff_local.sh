#!/bin/zsh

dotfiles=$HOME/dotfiles

cp $HOME/.vim/local_settings.vim .
cp $HOME/.vim/dein.toml dein_local.toml
cp $HOME/.vim/dein_lazy.toml dein_lazy_local.toml

cp $HOME/.xonshrc home/dot_xonshrc
cp $HOME/.config/oni/config.tsx oni_config.tsx
cp $HOME/.vimrc home/dot_vimrc
cp $HOME/.gvimrc home/dot_gvimrc

git -C $dotfiles add -N $dotfiles
git -C $dotfiles diff > diff_dotfiles.patch
git reset
