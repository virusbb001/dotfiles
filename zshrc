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

# run-help
unalias run-help >/dev/null 2>&1
autoload -Uz run-help

#vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
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
 esac
 zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

#PROMPT拡張
setopt prompt_subst

#TABで候補切り替える
setopt auto_menu
#補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1
#履歴を共有
setopt share_history
#cd時に自動でpush
setopt auto_pushd
#同じディレクトリはpushしない
setopt pushd_ignore_dups
#出力時8bit通す
setopt print_eight_bit
#同じコマンドをpushしない
setopt hist_ignore_dups
#補完候補を詰めて表示する
setopt list_packed
#=以降も補完
setopt magic_equal_subst
#自動でcd
setopt auto_cd

#キーをvim風に
bindkey -v

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "" history-beginning-search-backward-end
bindkey "" history-beginning-search-forward-end

#core生成
ulimit -c unlimited

# bindkey -a 'q' push-line

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


