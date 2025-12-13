#!/bin/zsh

dotfiles=$HOME/dotfiles

if [ -f $HOME/.vim/local_settings.vim ]; then
  cp $HOME/.vim/local_settings.vim .
fi

cp $HOME/.xonshrc home/.xonshrc
cp $HOME/.vimrc home/.vimrc
cp $HOME/.gvimrc home/.gvimrc

git -C $dotfiles add -N $dotfiles
git -C $dotfiles diff > diff_dotfiles.patch
git reset
