#!/bin/sh

export QT_QPA_PLATFORMTHEME=gtk3
export XCURSOR_SIZE=16

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null

setxkbmap -layout us,ru -option 'grp:caps_toggle'

xsetroot -cursor_name left_ptr &
# restore the last selected wallpaper (default-3.png on a fresh install)
"$HOME/.local/bin/setwall" &
picom --backend glx &
dunst &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

exec vxwm
