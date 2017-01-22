# envに書けないpath設定

echo "read dotfiles/zshrc"

source "$(dirname $0)/zsh/show_version.zsh"

# PATH
path=(
$HOME/.rbenv/shims(N-/)
$HOME/.rbenv/bin(N-/)
#nodebrew
$HOME/.nodebrew/current/bin(N-/)
$path
)

if which npm >/dev/null 2>&1; then
 node_path=(
 $(npm root -g)
 $node_path
 )
fi

export NODE_PATH

# autoload 
# -z でzsh-styleで関数をload
# -U エイリアス展開をしない
#補完機能強化
autoload -U compinit
#警告なしにすべての発見したファイルを使用
compinit -u

#色設定
autoload -U colors
colors

#add-zsh-hook
#イベント時に関数を複数定義できる
#
autoload -U add-zsh-hook

# run-help
unalias run-help >/dev/null 2>&1
autoload -Uz run-help

#vcs_info
autoload -Uz vcs_info
#git,hg,svnを有効に
zstyle ':vcs_info:*' enable git hg svn
# gitの変更を確認
zstyle ':vcs_info:git:*' check-for-changes true

#数値処理関数
zmodload zsh/mathfunc

### 履歴 ###
#履歴ファイルが未定義なら
if [ -z "$HISTFILE" ]; then
 HISTFILE=$HOME/.zsh_history
fi
#履歴
HISTSIZE=100000
#保存する履歴
SAVEHIST=100000
export HISTFILE HISTSIZE SAVEHIST
#履歴を共有
setopt share_history
#直近のヒストリと同じコマンドならばヒストリに追加しない
setopt hist_ignore_dups


#待機文字列
#PS1="${USER}@%M:%~%(!.#.$)> "
#%(!.#.$):
# %(x.x_is_true.x_is_false)
# !は特権かどうか
# $' 'はprintの引数のように処理する
local p_rhost="%M"
local zle_vi_mode="|   |"
if [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
 p_rhost="%F{yellow}%M%f"
else
 p_rhost="%F{green}%M%f"
fi
PROMPT=$'[%~]\n%(!|%F{red}|)%n%(!|%f|)@${p_rhost}${zle_vi_mode}%(!.#.$) > '
# viキーバインドの時モードをPROMPTに出力
# zle-line-initとzle-keymap-selectは特別な名前(zshzle)
function zle-line-init zle-keymap-select {
case $KEYMAP in
 vicmd)
  zle_vi_mode="|NOR|"
  ;;
  #bindkey -v時はmainとviinsは同じ
  main|viins)
  zle_vi_mode="|INS|" ;;
 command)
  zle_vi_mode="|CMD|" ;;
 *)
  zle_vi_mode="|XXX|" ;;

 esac
 zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

#PROMPT拡張
setopt prompt_subst
#PROMPT内で%文字から始まる置換機能を有効に
setopt prompt_percent

# 右プロンプトに関する設定
#右のプロンプトにvscの情報を表示
function _update_vcs_info_msg(){
#psvar初期化
psvar=()
#$vcs_info_msg_N_に情報代入
vcs_info
[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
# %Nvでpsvar[N]を出力
# %N(x.t.f)の.はtの文字列に含まれなければなんでも良い(%でエスケープできる)
# Nは括弧の直前でも直後でも良い
RPROMPT="%1(v|%1v|)"

#実行後は右プロンプト消去
setopt transient_rprompt

#TABで候補切り替える
setopt auto_menu
#cd時に自動でpush
setopt auto_pushd
#同じディレクトリはpushしない
setopt pushd_ignore_dups
#出力時8bit通す
setopt print_eight_bit
#補完候補を詰めて表示する
setopt list_packed
#=以降も補完
setopt magic_equal_subst
#自動でcd
setopt auto_cd
#間違えていると思われても訂正しない
setopt nocorrect
#曖昧な補完でもビープ音を鳴らさない
setopt nolist_beep
#EOF(^D)を入力されてもログアウトしない
setopt ignore_eof
#シェルエディタにおけるフロー制御を無効に
setopt no_flow_control
# 対話環境でも#以降をコメントに
setopt interactive_comments
#終了時にジョブ確認
setopt checkjobs
#数値でのソート順を1,10,2,20から1,2,10,20へ(数字通りに表示)
setopt numeric_glob_sort

#補完候補をメニューから選択
#  :completion:function:completer:command:argument:tag
#  らしい (zshcompsysのCONFIGRATIONで検索すれば多分出てくる)
zstyle ':completion:*:default' menu select

# rm以外は*.oを補完候補に出さない
zstyle ':completion:*:*:^(rm):*:*files' ignored-patterns '*.o'

### キー設定 ###
#キーをvim風に
bindkey -v

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "" history-beginning-search-backward-end
bindkey "" history-beginning-search-forward-end

#core生成
ulimit -c unlimited

# vicmd時(-a)にqでpush-line
#qは本来マクロ
bindkey -a 'q' push-line
# run-help
bindkey -a 'K' run-help

#ls
unalias ls >/dev/null 2>&1
if ls --color -d . >/dev/null 2>&1; then
 GNU_LS=1
 alias ls='ls --color=auto -vCF'
elif ls -G -d . >/dev/null 2>&1; then
 BSD_LS=1
 alias ls='ls -G -F'
else
 SOLARIS_LS=1
fi

#タイトル設定
case "${TERM}" in
 kterm*|xterm*)
  # xterm control sequences
  # OSC
  # http://www.xfree86.org/4.7.0/ctlseqs.html
  # iTerm2 title FAQ
  # https://www.iterm2.com/faq.html
  _set_command_title_precmd(){
   # nをつけないと改行が出力される
   # tab
   echo -en "\033];zsh - ready\007"
   #window
   echo -en "\033]2;zsh - ready\007"
  }
  _set_command_title_preexec(){
   # 引数1に対し末尾を削除(*はすべての文字)
   # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion
   echo -ne "\033];${1%% *}\007"
   echo -ne "\033]2;${1%% *}\007"
  }
  #複数登録
  # プロンプト表示直前
  # add-zsh-hook precmd _set_command_title_precmd
  # Enterを押してコマンドを実行する直前
  # add-zsh-hook preexec _set_command_title_preexec
  ;;
esac

if [[ ! -z "$VIRTUAL_ENV" ]] ; then
 echo "virtualenv"
 source "$VIRTUAL_ENV/bin/activate"
fi
