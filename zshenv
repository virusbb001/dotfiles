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
if [ -z "$EDITOR" -o $(which vim>/dev/null)] ; then
 EDITOR=vim
fi

export EDITOR

# chrome のオプション
typeset -xU google_chrome_option
google_chrome_option=(
# ローカルファイルへのアクセスを許可
"--allow-file-access-from-files"
# Same origin policyを無効に
# "--disable-web-security"
)
