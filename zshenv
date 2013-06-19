typeset -U path
path=(
 $HOME/bin(N-/)
 #個人的にソースから入れたものは$HOME/localに
 $HOME/local/bin(N-/)
 $path
 )

if [ -z "$LANG" ] ; then
 LANG="ja_JP.UTF-8"
fi
