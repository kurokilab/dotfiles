# ~/.zshrc — managed by dotfiles

# --- oh-my-zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="clean"
plugins=(git colored-man-pages sudo)
source "$ZSH/oh-my-zsh.sh"

# --- editor ---
export EDITOR=nvim
export VISUAL=nvim

# --- history ---
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_all_dups   # drop older duplicate of a command
setopt hist_ignore_space      # don't record commands starting with a space
setopt hist_reduce_blanks     # trim superfluous whitespace
setopt share_history          # share history across running shells

# --- zsh-autosuggestions (fish-like suggestions from history) ---
[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- fzf (Ctrl-R history, Ctrl-T files, Alt-C cd) ---
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# --- zoxide (smarter cd; `z <dir>` and `zi` for interactive) ---
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

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

# --- zsh-syntax-highlighting (must be sourced last) ---
[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- other ---
alias ls="eza --all --icons"
alias ll="eza -al --icons"
