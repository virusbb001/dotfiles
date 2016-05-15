# このファイル読み込み前に設定しておくべきこと
# LANGの変数

# PATH系変数設定
typeset -T NODE_PATH node_path
typeset -U path fpath manpath node_path
path=(
$HOME/bin(N-/)
#個人的にソースから入れたものは$HOME/localに
$HOME/local/bin(N-/)
$path
$ECLIPSE_HOME(N-/)
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

# エディタ
if [[ -z "$EDITOR" ]] && which vim>/dev/null ; then
 EDITOR=vim
fi

export EDITOR

# chrome のオプション
typeset -xU google_chrome_option
google_chrome_option=(
# ローカルファイルへのアクセスを許可
"--allow-file-access-from-files"
# Same origin policyを無効に
"--disable-web-security"
)

case "${OSTYPE}" in
 # Mac用
 darwin*)
 if [ -e "$HOME/dotfiles/zsh/darwin.zsh" ] ; then
  source ~/dotfiles/zsh/darwin.zsh
 fi
 ;;
 # Linux用
 linux*)
 ;;
esac
