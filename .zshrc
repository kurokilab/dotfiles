# ~/.zshrc — managed by dotfiles

# --- oh-my-zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git colored-man-pages)
source "$ZSH/oh-my-zsh.sh"

# --- editor ---
export EDITOR=nvim
export VISUAL=nvim

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
