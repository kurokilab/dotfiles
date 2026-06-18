# dotfiles

Personal configuration for a minimal Arch Linux setup built around the
[vxwm](https://codeberg.org/wh1tepearl/vxwm) tiling window manager and X11.

These dotfiles are meant to be applied to a **bare Arch Linux install** — a
freshly bootstrapped base system with networking and a regular (non-root) user.
The installer pulls in every package the configs expect, builds and installs
`vxwm` from source, and links the configuration into place. There is no
desktop environment to remove or work around; the scripts assume nothing is set
up yet.

## Installation

Quick install — bootstrap straight from curl. The script clones the repo into
`~/.dotfiles` (override with `$DOTFILES`) and re-runs itself from there:

```sh
bash <(curl -Ls https://raw.githubusercontent.com/kurokilab/dotfiles/main/install.sh)
```

Or clone manually and run it in place:

```sh
git clone https://github.com/kurokilab/dotfiles.git
cd dotfiles
./install.sh
```

Either way, do **not** run it as root — it installs configs into your home
directory and uses `sudo` only where needed.

A full run will:

1. Install all dependencies via `pacman` (`base-devel`, Xorg, fonts, and the
   applications above).
2. Clone, configure (`vxwm/config.h`), build, and install vxwm and the `rvx`
   helper into `/usr/local/bin`.
3. Sync the wallpapers, `.xinitrc`, `.gtkrc-2.0`, `~/.config` entries,
   `.zshrc`, and `.gitconfig` into the home directory.
4. Install oh-my-zsh (unattended) and set zsh as the default shell.
5. Install `ly/config.ini` to `/etc/ly/config.ini` and enable
   `ly@tty2.service`.

After installation, ly starts at the next boot. To start the session manually
without ly, run `startx`.

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
| Browser          | Chromium (default), Firefox                    |
| Wallpaper        | feh                                            |
| Theming          | Adwaita-dark (GTK 2/3/4, Qt via `gtk3` portal) |

Additional configured applications: cmus, cava, fastfetch.

## Layout

```
.
├── install.sh           installer / updater
├── wallpapers/          wallpapers synced into ~/Wallpapers (default: default-3.png)
├── home/                files installed into ~
│   ├── .local/bin/      helper scripts           → ~/.local/bin
│   │   ├── setwall      wallpaper restore/randomizer
│   │   ├── screenshot   region screenshot
│   │   └── volume       volume control + on-screen popup
│   ├── .xinitrc         X session startup        → ~/.xinitrc
│   ├── .zshrc           shell configuration      → ~/.zshrc
│   ├── .gitconfig       global git configuration → ~/.gitconfig
│   └── gtkrc-2.0        GTK2 dark theme          → ~/.gtkrc-2.0
├── vxwm/
│   └── config.h         vxwm build-time configuration
├── ly/
│   └── config.ini       ly display manager config → /etc/ly/config.ini
└── config/              mirrored into ~/.config
    ├── mimeapps.list    default app associations  → ~/.config/mimeapps.list
    ├── alacritty/
    ├── git/             global git ignore        → ~/.config/git/ignore
    ├── nvim/
    ├── picom/
    ├── dunst/
    ├── nnn/
    ├── Thunar/
    ├── cmus/  cava/  fastfetch/
    └── gtk-3.0/  gtk-4.0/
```

## Requirements

- A working Arch Linux base install
- A non-root user with `sudo` privileges (the installer refuses to run as root)
- An internet connection (pacman, oh-my-zsh, and the vxwm clone)

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

- Keyboard layout is set to `us,ru` toggled with `Caps Lock` (see `.xinitrc`).
- Wallpapers live in `~/Wallpapers` and are driven by `~/.local/bin/setwall`.
  At login `.xinitrc` restores the last selected wallpaper; `Super+Ctrl+W`
  picks a new random one (`.jpg`, `.jpeg`, `.png`) and `Super+Shift+W` opens a
  file dialog (zenity) to choose any image on disk. Either way the choice is
  remembered for next time in `~/.cache/wallpaper`; on a fresh install it
  defaults to `default-3.png`. Drop images into the repo's `wallpapers/`
  directory and re-run the installer to add more.
- Screenshots are driven by `~/.local/bin/screenshot` (maim + slop).
  `Super+Shift+S` selects a region and copies it to the clipboard;
  `Super+Ctrl+S` also saves a timestamped PNG to `~/Pictures/Screenshots`.
  Cancel the selection with `Esc` or right-click.
- Volume is driven by `~/.local/bin/volume` (pactl). `Super+]` raises and
  `Super+[` lowers the default sink in 5% steps (clamped to 100%), and
  `Super+M` toggles mute. Each change shows a minimal dunst popup with a
  progress bar reflecting the current level; repeated presses replace the popup
  rather than stacking.
- Application launch keys: `Super+Return` opens Alacritty, `Super+D` the dmenu
  launcher, `Super+W` Chromium, and `Super+O` Obsidian.
- The Qt platform theme is forced to `gtk3` so Qt apps follow the GTK dark
  theme.
- Default applications are set in `~/.config/mimeapps.list`, read by
  `xdg-open` and Thunar: Chromium for web pages and URLs, mupdf for PDF/EPUB,
  feh for images, VLC for audio, mpv for video, xarchiver for archives, and
  Thunar for directories. These mirror the routing in `~/.config/nnn/opener`,
  so files open the same way from nnn, Thunar, or any app that calls
  `xdg-open`.
- Removable drives are auto-mounted by `udiskie` (started from `.xinitrc`),
  which sits on top of `udisks2` and notifies on insert/remove via dunst.
  Mounted media show up under `/run/media/$USER` and in Thunar; right-click a
  device there to unmount.
- `.zshrc` provides two yt-dlp wrappers: `getaudio <url>` extracts audio as
  mp3 into `~/Music/Downloads`, and `getvideo <url>` downloads best
  video+audio into `~/Videos/Downloads`.
- The shell is augmented with zsh-autosuggestions (history-based inline
  suggestions), zsh-syntax-highlighting, fzf (`Ctrl+R` history, `Ctrl+T`
  files, `Alt+C` cd), and zoxide (`z <dir>` jumps to frequently used
  directories, `zi` for interactive picking). All four are installed from the
  official repos and sourced from `/usr/share/zsh/plugins` and the `fzf`/
  `zoxide` binaries, so there are no extra clones to maintain.
- vxwm is configured at compile time; edit `vxwm/config.h` and re-run the
  installer (or `--skip-deps`) to rebuild.

## License

MIT — see [LICENSE](LICENSE).
