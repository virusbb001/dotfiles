#!/usr/bin/bash

function :tabdrop () {
if [[ $# -lt 1 ]]; then
  cat << HELP
  :tabdrop [filename]
HELP
  return 1
fi
file=$(realpath "$1")
# nvim -u NONE -es -c "call rpcrequest(sockconnect(\"pipe\", \"$NVIM\", #{rpc: 1}), \"nvim_command\", \"tab drop $file\")" +q
nvim --server "$NVIM" --remote "$file"

echo "opened $file"
}

function :cd () {
nvim -u NONE -es -c "call rpcrequest(sockconnect(\"pipe\", \"$NVIM\", #{rpc: 1}), \"nvim_command\", \"cd $(pwd)\")" +q
}

alias :tabnew=':tabdrop'
alias tabdrop=':tabdrop'

complete -f :tabdrop

if [[ -z "$NVIM" ]]; then
  unset :tabnew :tabdrop tabdrop :cd
fi
