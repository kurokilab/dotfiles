# dotfiles

Personal configuration for a minimal Arch Linux setup built around the
[vxwm](https://codeberg.org/wh1tepearl/vxwm) tiling window manager and X11.

These dotfiles are meant to be applied to a **bare Arch Linux install** — a
freshly bootstrapped base system with networking and a regular (non-root) user.
The installer pulls in every package the configs expect, builds and installs
`vxwm` from source, and links the configuration into place. There is no
desktop environment to remove or work around; the scripts assume nothing is set
up yet.

## What's included

| Component        | Tool                                          |
| ---------------- | --------------------------------------------- |
| Window manager   | vxwm (built from source, custom `config.h`)   |
| Display manager  | ly                                             |
| Session startup  | `.xinitrc` (X11 / `startx`)                    |
| Terminal         | Alacritty                                      |
| Shell            | zsh + oh-my-zsh                                |
| Compositor       | picom (glx backend)                            |
| Notifications    | dunst                                          |
| Launcher         | dmenu                                          |
| Editor           | Neovim (lazy.nvim)                             |
| File managers    | nnn (CLI), Thunar (GUI)                        |
| Wallpaper        | feh                                            |
| Theming          | Adwaita-dark (GTK 2/3/4, Qt via `gtk3` portal) |

Additional configured applications: cmus, cava, mpv/vlc, zathura, btop,
fastfetch, keepassxc, obsidian, chromium.

## Layout

```
.
├── install.sh        installer / updater
├── wallpapers.jpg    default wallpaper
├── home/             files installed into ~
│   ├── .xinitrc      X session startup        → ~/.xinitrc
│   ├── .zshrc        shell configuration      → ~/.zshrc
│   └── gtkrc-2.0     GTK2 dark theme          → ~/.gtkrc-2.0
├── vxwm/
│   └── config.h      vxwm build-time configuration
└── config/           mirrored into ~/.config
    ├── alacritty/
    ├── nvim/
    ├── picom/
    ├── dunst/
    ├── nnn/
    ├── Thunar/
    ├── cmus/  cava/  fastfetch/
    ├── gtk-3.0/  gtk-4.0/
    └── ly.config.ini  → installed to /etc/ly/config.ini
```

## Requirements

- A working Arch Linux base install
- A non-root user with `sudo` privileges (the installer refuses to run as root)
- An internet connection (pacman, oh-my-zsh, and the vxwm clone)

## Installation

```sh
git clone https://github.com/kurokilab/dotfiles.git
cd dotfiles
./install.sh
```

A full run will:

1. Install all dependencies via `pacman` (`base-devel`, Xorg, fonts, and the
   applications above).
2. Clone, configure (`vxwm/config.h`), build, and install vxwm and the `rvx`
   helper into `/usr/local/bin`.
3. Sync the wallpaper, `.xinitrc`, `.gtkrc-2.0`, `~/.config` entries, and
   `.zshrc` into the home directory.
4. Install oh-my-zsh (unattended) and set zsh as the default shell.
5. Install `config/ly.config.ini` to `/etc/ly/config.ini` and enable
   `ly@tty2.service`.

After installation, ly starts at the next boot. To start the session manually
without ly, run `startx`.

## Options

```
./install.sh                  full install or update (dotfiles + system)
./install.sh --dotfiles-only  only sync dotfiles (no sudo / pacman)
./install.sh --skip-deps      skip the pacman dependency step
./install.sh -h | --help      show usage
```

## Idempotency

Re-running the installer is safe. Files are written only when their contents
actually differ; new files are added and unrelated files in the home directory
are left untouched. Any real (non-symlink) file that gets overwritten with
different content is backed up once to `<file>.bak`. The same applies to
`/etc/ly/config.ini` and `vxwm/config.h`.

Use `--dotfiles-only` for a fast configuration refresh once the system packages
and vxwm are already in place.

## Notes

- Keyboard layout is set to `us,ru` toggled with `Alt+Shift` (see `.xinitrc`).
- The Qt platform theme is forced to `gtk3` so Qt apps follow the GTK dark
  theme.
- vxwm is configured at compile time; edit `vxwm/config.h` and re-run the
  installer (or `--skip-deps`) to rebuild.

## License

MIT — see [LICENSE](LICENSE).
