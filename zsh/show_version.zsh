# version/package manger init

if which rbenv >/dev/null 2>&1; then
 eval "$(rbenv init -)"
fi

if [ -f ${PERLBREW_ROOT:-"${HOME}/perl5/perlbrew"}/etc/bashrc ]; then
 source ${PERLBREW_ROOT:-"${HOME}/perl5/perlbrew"}/etc/bashrc
fi

# phpbrew
if which phpbrew >/dev/null 2>&1; then
 source ~/.phpbrew/bashrc
 if which brew >/dev/null 2>&1; then
  phpbrew lookup-prefix homebrew
 fi
fi

function show_version() {
## version/package manager show version

# rbenv
if which rbenv >/dev/null 2>&1; then
 rbenv --version
fi

# nodebrew
if which nodebrew >/dev/null 2>&1; then
 nodebrew |head -n 1
fi

# perlbrew
if which perlbrew >/dev/null 2>&1; then
 perlbrew version
fi

# homebrew
if which brew >/dev/null 2>&1; then
 brew --version
fi

return 0
}
