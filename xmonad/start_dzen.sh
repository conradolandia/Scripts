#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# little modification by rejuvyesh

# initalizes dzen bars

HOSTNAME=$(hostname)

# dzen values
FG='#dddddd' # dzen foreground
BG="#000000" # dzen background
#FN="-xos4-terminus-medium-*-*-*-12-*-*-*-*-*-*-*" # font
FN="Consolas:size=8"
E="sigusr1=raise;sigusr2=lower"
H="13"

WIDTH="1366"
HEIGHT="768"

TRAYER="trayer --edge bottom --align right --SetDockType true --SetPartialStrut true --expand true --width 28 --height $H --transparent true --tint 0x000000 --alpha 10 --widthtype pixel"

DZEN="dzen2 -p -fg '$FG' -bg '$BG' -fn '$FN' -e '$E' -h '$H' -y '$(($HEIGHT - $H))'"
DZEN_LEFT="$DZEN -x '0' -w '566' -ta 'l'"
DZEN_RIGHT="$DZEN -w '$(( 800 - 28 ))' -x '$(( $WIDTH - 800 ))' -ta 'r'"

# make 2 pipes - one for xmonad's output and one for the status bar
XPIPE=~/.xmonad/xmonad-pipe
SPIPE=~/.xmonad/status-pipe

PIPES=($XPIPE $SPIPE)
for pipe in $PIPES; do
if [[ -e $pipe && -p $pipe ]]; then
echo "reusing pipe '$pipe'..."
  else
rm -f $pipe
    mkfifo -m 600 $pipe
    [ -p $pipe ] || { echo "This is not a pipe."; exit 1 }
  fi
done

killall -q dzen2

# launch xmonad's dzen
eval "$DZEN_LEFT < $XPIPE &"

# launch status dzen
eval "$DZEN_RIGHT < $SPIPE &"

# launch trayer
eval "$TRAYER &"
