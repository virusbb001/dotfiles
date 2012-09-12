#補完機能強化
autoload -U compinit
compinit

#色設定
autoload -U colors
colors

#数値処理関数
zmodload -i zsh/mathfunc

#履歴ファイル
HISTFILE=$HOME/.zsh_history
#履歴
HISTSIZE=100000
#保存する履歴
SAVEHIST=100000
#待機文字列
PS1="zsh@${USER}@%M:%~%(!.#.$)> "
#いろいろ便利になる
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
#bindkey -v


autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "" history-beginning-search-backward-end
bindkey "" history-beginning-search-forward-end

bindkey -a 'q' push-line
