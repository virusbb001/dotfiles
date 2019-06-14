#!/bin/zsh

dotfiles=$HOME/dotfiles

if [ -f $HOME/.vim/local_settings.vim ]; then
  cp $HOME/.vim/local_settings.vim .
fi
if [ -f $HOME/.vim/dein.toml ]; then
  cp $HOME/.vim/dein.toml dein_local.toml
fi
if [ -f $HOME/.vim/dein_lazy.toml ]; then
cp $HOME/.vim/dein_lazy.toml dein_lazy_local.toml
fi

cp $HOME/.xonshrc home/.xonshrc
cp $HOME/.vimrc home/.vimrc
cp $HOME/.gvimrc home/.gvimrc

git -C $dotfiles add -N $dotfiles
git -C $dotfiles diff > diff_dotfiles.patch
git reset
