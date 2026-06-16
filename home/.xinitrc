#!/bin/sh

export QT_QPA_PLATFORMTHEME=gtk3
export XCURSOR_SIZE=16

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null

setxkbmap -layout us,ru -option 'grp:caps_toggle'

xsetroot -cursor_name left_ptr &
# pick a random wallpaper from ~/Wallpapers on each session start
feh --bg-scale "$(find ~/Wallpapers -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | shuf -n1)" &
picom --backend glx &
dunst &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

exec vxwm
