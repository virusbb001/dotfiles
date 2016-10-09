function show_version() {
## version/package manager

# rbenv
if which rbenv >/dev/null 2>&1; then
 eval "$(rbenv init -)"
 rbenv --version
fi

# nodebrew
if which nodebrew >/dev/null 2>&1; then
 nodebrew |head -n 1
fi

# perlbrew
if [ -f ${PERLBREW_ROOT:-"${HOME}/perl5/perlbrew"}/etc/bashrc ]; then
 source ${PERLBREW_ROOT:-"${HOME}/perl5/perlbrew"}/etc/bashrc
 perlbrew version
fi

# homebrew
if which brew >/dev/null 2>&1; then
 brew --version
fi

# phpbrew
if which phpbrew >/dev/null 2>&1; then
 source ~/.phpbrew/bashrc
 if which brew >/dev/null 2>&1; then
  phpbrew lookup-prefix homebrew
 fi
fi
return 0
}
