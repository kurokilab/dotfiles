# ~/.zshrc — managed by dotfiles

# --- oh-my-zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git colored-man-pages)
source "$ZSH/oh-my-zsh.sh"

# --- editor ---
export EDITOR=nvim
export VISUAL=nvim

# --- yt-dlp downloaders ---
# getaudio <url> — extract best audio (mp3) into ~/Music/Downloads
getaudio() {
    yt-dlp -x --audio-format mp3 --audio-quality 0 \
        -o "$HOME/Music/Downloads/%(title)s.%(ext)s" "$@"
}

# getvideo <url> — download best video+audio into ~/Videos/Downloads
getvideo() {
    yt-dlp -f "bv*+ba/b" \
        -o "$HOME/Videos/Downloads/%(title)s.%(ext)s" "$@"
}

# --- nnn ---
export NNN_OPENER="$HOME/.config/nnn/opener"

# wrapper: cd into the directory nnn was in when you quit with `q`
n() {
    [ "${NNNLVL:-0}" -eq 0 ] || { echo "nnn is already running"; return; }
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    command nnn -c "$@"
    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE"
    fi
}
