#! /usr/bin/bash

set -euo pipefail

# ============================================================================
#  dotfiles installer / updater
#
#  Usage:
#    ./install.sh                 full install or update (dotfiles + system)
#    ./install.sh --dotfiles-only only sync dotfiles (fast, no sudo/pacman)
#    ./install.sh --skip-deps     skip the pacman dependency step
#    ./install.sh -h | --help     show this help
#
#  Re-running is safe: existing files are updated in place only when their
#  contents actually changed, brand-new files are added, and unrelated files
#  in your home dir are left untouched. A one-time .bak is kept for any real
#  file that gets overwritten with different content.
# ============================================================================

if [ "$(id -u)" -eq 0 ]; then
    echo "error: do not run this script as root." >&2
    echo "       it installs configs into your home dir and uses sudo where needed." >&2
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VXWM_REPO="https://codeberg.org/wh1tepearl/vxwm.git"
VXWM_DIR="/opt/vxwm"
VXWM_CONFIG="${DOTFILES_DIR}/vxwm/config.h"

PREFIX="/usr/local"

# runtime flags
DOTFILES_ONLY=0
SKIP_DEPS=0

usage() {
    sed -n '4,18p' "${BASH_SOURCE[0]}" | sed 's/^#  \{0,1\}//; s/^#//'
}

parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --dotfiles-only) DOTFILES_ONLY=1 ;;
            --skip-deps)     SKIP_DEPS=1 ;;
            -h|--help)       usage; exit 0 ;;
            *) echo "error: unknown option '$1' (try --help)" >&2; exit 1 ;;
        esac
        shift
    done
}

# ---------------------------------------------------------------------------
#  sync helpers — update existing files, add new ones, skip unchanged
# ---------------------------------------------------------------------------

# sync_file <src> <dst>
# Copies src -> dst only when dst is missing or differs from src.
# A differing real (non-symlink) dst is backed up once to dst.bak.
sync_file() {
    local src="$1" dst="$2"

    [ -f "${src}" ] || { echo "   ! source ${src} missing, skipping"; return; }

    mkdir -p "$(dirname "${dst}")"

    if [ -e "${dst}" ] && [ ! -L "${dst}" ] && cmp -s "${src}" "${dst}"; then
        return  # already up to date
    fi

    if [ -e "${dst}" ] && [ ! -L "${dst}" ]; then
        echo "   backing up ${dst} -> ${dst}.bak"
        cp -f "${dst}" "${dst}.bak"
        echo "   updated ${dst}"
    else
        echo "   added   ${dst}"
    fi

    cp -f "${src}" "${dst}"
}

# sync_tree <src_dir> <dst_dir> [exclude_basename ...]
# Recursively syncs every file under src_dir into dst_dir, preserving the
# relative layout. New files are added, changed files updated, everything
# else (including unrelated files already in dst_dir) is left alone.
sync_tree() {
    local src_dir="$1" dst_dir="$2"
    shift 2
    local excludes=("$@")

    [ -d "${src_dir}" ] || { echo "   no ${src_dir}, skipping"; return; }

    local src rel dst skip ex
    while IFS= read -r -d '' src; do
        rel="${src#"${src_dir}"/}"

        skip=0
        for ex in "${excludes[@]}"; do
            case "${rel}" in
                "${ex}"|"${ex}"/*) skip=1; break ;;
            esac
        done
        [ "${skip}" -eq 1 ] && continue

        dst="${dst_dir}/${rel}"
        sync_file "${src}" "${dst}"
    done < <(find "${src_dir}" -type f -print0)
}

# ---------------------------------------------------------------------------
#  install / update steps
# ---------------------------------------------------------------------------

install_wallpaper() {
    echo ":: Syncing wallpapers..."
    sync_tree "${DOTFILES_DIR}/wallpapers" "${HOME}/Wallpapers"
}

install_bin() {
    echo ":: Syncing ~/.local/bin scripts..."
    sync_tree "${DOTFILES_DIR}/home/.local/bin" "${HOME}/.local/bin"
    # helper scripts are spawned directly (login, keybindings), so they must
    # be executable.
    find "${HOME}/.local/bin" -maxdepth 1 -type f -exec chmod +x {} +
}

install_deps() {
    echo ":: Installing dependencies..."
    sudo pacman -Suy --needed base-devel git libx11 libxft libxinerama make freetype2 qt6-base \
        xorg-server xorg-xinit xorg-xrandr xorg-xsetroot xorg-xprop xorg-xset xorg-xev xdotool xclip \
        ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono  \
        ttf-jetbrains-mono noto-fonts-emoji arandr nano btop alacritty ly feh picom pavucontrol \
        tree nnn neovim fail2ban obsidian chromium keepassxc dmenu dunst libnotify \
        zsh curl ufw mpv vlc mupdf cmus cava 7zip fastfetch \
        thunar thunar-volman thunar-archive-plugin tumbler ffmpegthumbnailer \
        gvfs gvfs-mtp xarchiver \
        polkit polkit-gnome \
        dconf gsettings-desktop-schemas xdg-desktop-portal xdg-desktop-portal-gtk \
        gnome-themes-extra nodejs npm go gopls clang pyright unzip less ripgrep fd
}

install_vxwm() {
    echo ":: Installing/updating vxwm from ${VXWM_REPO}..."

    if [ -d "${VXWM_DIR}/.git" ]; then
        echo "   updating existing clone at ${VXWM_DIR}"
        sudo git -C "${VXWM_DIR}" pull --ff-only
    else
        echo "   cloning into ${VXWM_DIR}"
        sudo rm -rf "${VXWM_DIR}"
        sudo mkdir -p "$(dirname "${VXWM_DIR}")"
        sudo git clone "${VXWM_REPO}" "${VXWM_DIR}"
    fi

    if [ -f "${VXWM_CONFIG}" ]; then
        if sudo cmp -s "${VXWM_CONFIG}" "${VXWM_DIR}/config.h"; then
            echo "   config.h already up to date"
        else
            echo "   applying custom config.h"
            sudo cp -f "${VXWM_CONFIG}" "${VXWM_DIR}/config.h"
        fi
    fi

    echo ":: Building and installing vxwm..."
    sudo make -C "${VXWM_DIR}" clean install

    echo ":: Installing rvx helper..."
    sudo install -Dm755 "${VXWM_DIR}/rvx" "${PREFIX}/bin/rvx"
}

install_xinitrc() {
    echo ":: Syncing ~/.xinitrc..."
    sync_file "${DOTFILES_DIR}/home/.xinitrc" "${HOME}/.xinitrc"
    # ly execs ~/.xinitrc as a command, so it must be executable (startx
    # tolerates a non-executable file, ly does not).
    [ -f "${HOME}/.xinitrc" ] && chmod +x "${HOME}/.xinitrc"
}

install_gtkrc2() {
    echo ":: Syncing ~/.gtkrc-2.0 (dark theme for GTK2 apps)..."
    sync_file "${DOTFILES_DIR}/home/gtkrc-2.0" "${HOME}/.gtkrc-2.0"
}

install_configs() {
    echo ":: Syncing ~/.config entries..."
    sync_tree "${DOTFILES_DIR}/config" "${HOME}/.config"
}

setup_nnn() {
    echo ":: Configuring nnn opener..."

    local opener="${HOME}/.config/nnn/opener"
    if [ -f "${opener}" ]; then
        chmod +x "${opener}"
    else
        echo "   ${opener} not found, skipping chmod"
    fi
    # nnn env vars (EDITOR/VISUAL/NNN_OPENER) live in ~/.zshrc, see install_zshrc
}

install_ohmyzsh() {
    echo ":: Installing oh-my-zsh (from ohmyz.sh)..."

    if [ -d "${HOME}/.oh-my-zsh" ]; then
        echo "   already present at ${HOME}/.oh-my-zsh, skipping"
        return
    fi

    # official unattended install:
    #   --unattended  -> RUNZSH=no, CHSH=no (we handle the shell ourselves)
    #   KEEP_ZSHRC=yes -> don't generate a default .zshrc (install_zshrc copies ours)
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://install.ohmyz.sh/)" "" --unattended
}

install_zshrc() {
    echo ":: Syncing ~/.zshrc..."
    sync_file "${DOTFILES_DIR}/home/.zshrc" "${HOME}/.zshrc"
}

set_default_shell() {
    echo ":: Setting zsh as the default shell..."

    local zsh_path
    zsh_path="$(command -v zsh || true)"
    if [ -z "${zsh_path}" ]; then
        echo "   zsh not found, skipping"
        return
    fi

    # zsh must be listed in /etc/shells, otherwise chsh refuses and (worse)
    # some PAM setups reject logins for a user whose shell is "invalid".
    if ! grep -qxF "${zsh_path}" /etc/shells 2>/dev/null; then
        echo "   ${zsh_path} not in /etc/shells, adding it"
        echo "${zsh_path}" | sudo tee -a /etc/shells >/dev/null
    fi

    # Check the *actual* login shell from /etc/passwd, not $SHELL: the env var
    # reflects the current process's shell, not what's configured for the user.
    local current_shell
    current_shell="$(getent passwd "${USER}" | cut -d: -f7)"
    if [ "${current_shell}" = "${zsh_path}" ]; then
        echo "   already ${zsh_path}, skipping"
        return
    fi

    sudo chsh -s "${zsh_path}" "${USER}"
}

setup_ly() {
    echo ":: Configuring ly..."

    local src="${DOTFILES_DIR}/ly/config.ini"
    local dst="/etc/ly/config.ini"

    if [ ! -f "${src}" ]; then
        echo "   ${src} not found, skipping"
        return
    fi

    sudo mkdir -p /etc/ly

    if sudo cmp -s "${src}" "${dst}" 2>/dev/null; then
        echo "   ${dst} already up to date"
    else
        if [ -f "${dst}" ] && [ ! -L "${dst}" ]; then
            echo "   backing up existing ${dst} -> ${dst}.bak"
            sudo cp -f "${dst}" "${dst}.bak"
        fi
        sudo install -Dm644 "${src}" "${dst}"
    fi

    echo ":: Enabling ly at boot..."
    sudo systemctl enable --now ly@tty2.service
}

# ---------------------------------------------------------------------------

sync_dotfiles() {
    install_wallpaper
    install_bin
    install_xinitrc
    install_gtkrc2
    install_configs
    install_zshrc
    setup_nnn
}

main() {
    parse_args "$@"

    if [ "${DOTFILES_ONLY}" -eq 1 ]; then
        echo ":: Dotfiles-only update..."
        sync_dotfiles
        echo ":: Done. Dotfiles are up to date."
        return
    fi

    [ "${SKIP_DEPS}" -eq 1 ] && echo ":: Skipping dependency install (--skip-deps)" || install_deps
    install_vxwm
    sync_dotfiles
    install_ohmyzsh
    set_default_shell
    setup_ly

    echo ":: Done. ly will start at next boot."
}

main "$@"
