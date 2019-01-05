# このファイル読み込み前に設定しておくべきこと
# LANGの変数

# PATH系変数設定
typeset -T NODE_PATH node_path
typeset -Tx XDG_CONFIG_DIRS xdg_config_dirs

typeset -U path fpath manpath node_path xdg_config_dirs

dotfiles="$HOME/dotfiles"

path=(
$HOME/bin(N-/)
$HOME/local/bin(N-/)
$path
$ECLIPSE_HOME(N-/)
)

if which go >/dev/null 2>&1; then
  path=($(go env GOPATH)/bin $path)
fi

if which ruby >/dev/null 2>&1; then
  path=(
  $(ruby -e 'print Gem.user_dir')/bin(N-/)
  $path
  )
fi

if which python3 >/dev/null 2>&1; then
  path=(
  $(python3 -m site --user-base)/bin(N-/)
  $path
  )
fi

if which python2 >/dev/null 2>&1; then
  path=(
  $(python2 -m site --user-base)/bin(N-/)
  $path
  )
fi

fpath=(
$dotfiles/zsh-completions/src(N-/)
/usr/local/share/zsh/site-functions(N-/)
$fpath
)

manpath=(
$manpath
)

xdg_config_dirs=(
$dotfiles/config
$xdg_config_dirs
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
 if [ -e "$dotfiles/zsh/darwin.zsh" ] ; then
  source ~/dotfiles/zsh/darwin.zsh
 fi
 ;;
 # Linux用
 linux*)
 ;;
esac
