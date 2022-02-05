#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
XAUTHORITY=$HOME/.Xauthority

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

session=${1:-i3}

case $session in
	# without systemd-free gvfs fix
	#i3|i3wm ) exec i3;;
	#bspwm ) exec bspwm;;
	# with systemd-free gvfs fix
	i3|i3wm ) exec dbus-launch --exit-with-session i3;;
	bspwm ) exec dbus-launch --exit-with-session bspwm;;
	# running this command by using known session
	* ) exec $1;;
esac

