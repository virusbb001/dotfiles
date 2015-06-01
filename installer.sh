#!/bin/sh

# $0 実行スクリプト
cd `dirname $0`

if [[ ! -f ~/.vimrc ]]; then
 install -m 0644 dot_vimrc ~/.vimrc
else
 echo ".vimrc already exists. skip"
fi

if [[ ! -f ~/.zshrc ]]; then
 install -m 0644 dot_zshrc ~/.zshrc
else
 echo ".zshrc already exists. skip"
fi
