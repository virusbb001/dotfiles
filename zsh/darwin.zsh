# for OS X

# add VLC

if ! which vlc >/dev/null 2>&1; then
 if [[ -e /Applications/VLC.app/Contents/MacOS/VLC ]]; then
  alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
 elif [[ -e $HOME//Applications/VLC.app/Contents/MacOS/VLC ]]; then
  alias vlc='$HOME/Applications/VLC.app/Contents/MacOS/VLC'
 fi
fi
