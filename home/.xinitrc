#!/bin/sh

export QT_QPA_PLATFORMTHEME=gtk3
export XCURSOR_SIZE=16
export GTK_THEME=Adwaita:dark
export ADW_DEBUG_COLOR_SCHEME=prefer-dark

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null

xset r rate 250 50
xsetroot -cursor_name left_ptr &
"$HOME/.local/bin/setwall" &
picom &
dunst &
quickshell &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
udiskie &

exec vxwm
