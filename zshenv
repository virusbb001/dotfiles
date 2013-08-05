# このファイル読み込み前に設定しておくべきこと
# LANGの変数
#
#
typeset -U path fpath manpath
path=(
 $HOME/bin(N-/)
 #個人的にソースから入れたものは$HOME/localに
 $HOME/local/bin(N-/)
 # phpenv(デフォルト)
 $HOME/.phpenv/bin(N-/)
 $path
 )

fpath=(
 $HOME/dotfiles/zsh-completions/src(N-/)
 /usr/local/share/zsh/site-functions(N-/)
 $fpath
)

manpath=(
 $manpath
)

# LANGが特に指定されてなければ
if [ -z "$LANG" ] ; then
 LANG="ja_JP.UTF-8"
fi

#TERMがLinuxだったらLANGをCに
case "$TERM" in
 "linux" ) LANG=C ;;
 * ) 
  ;;
esac
#ttyがconsoleかttyv[0-9]だったらCに
case `tty` in
 /dev/console|/dev/ttyv[0-9])
  LANG=C
 ;;
 * )
 ;;
esac

export LANG

export EDITOR=vim
