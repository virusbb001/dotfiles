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
zmodload -i zsh/mathfunc

#履歴ファイル
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
PROMPT=$'[%~]\n%n@${p_rhost}${zle_vi_mode}%(!.#.$) > '
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

#右のプロンプトにvscの情報を表示
function _update_vcs_info_msg(){
 psvar=()
 vcs_info
 [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

add-zsh-hook precmd _update_vcs_info_msg
# %Nvでpsvar[N]を出力
# %N(x.t.f)の.はtの文字列に含まれなければなんでも良い(%でエスケープできる)
# Nは括弧の直前でも直後でも良い
RPROMPT="%1(v|%1v|)"

#タイトル設定
case "${TERM}" in
 kterm*|xterm*)
  _set_command_title_precmd(){
   echo -ne "\033]2;zsh\007"
  }
  _set_command_title_preexec(){
   echo -ne "\033]2;${1%% *}\007"
  }
  #複数登録
  add-zsh-hook precmd _set_command_title_precmd
  add-zsh-hook preexec _set_command_title_preexec
  ;;
esac

#PROMPT拡張
setopt prompt_subst
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

#補完候補をメニューから選択
zstyle ':completion:*:default' menu select=1

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

bindkey -a 'K' run-help

#TERMがLinuxだったらLANGをCに
case "$TERM" in
 "linux" ) LANG=C ;;
 * ) 
  if [ -z "$LANG" ]; then
   LANG="ja_JP.UTF-8"
  fi ;;
esac
export LANG

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


