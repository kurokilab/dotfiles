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
   `~/.local/share/applications` launchers, `.zshrc`, and `.gitconfig` into
   the home directory.
4. Install oh-my-zsh (unattended) and set zsh as the default shell.
5. Install `ly/config.ini` to `/etc/ly/config.ini` and enable
   `ly@tty2.service`.
6. Install `x11/30-libinput.conf` to
   `/etc/X11/xorg.conf.d/30-libinput.conf` (mouse/touchpad settings).

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
| Compositor       | picom (egl backend)                            |
| Status bar       | Quickshell (gruvbox, tags / clock / tray)      |
| Notifications    | dunst                                          |
| Launcher         | rofi (gruvbox dark theme)                      |
| Editor           | Neovim (lazy.nvim)                             |
| File managers    | yazi (CLI), Thunar (GUI)                       |
| Browser          | Chromium (default), Firefox                    |
| Wallpaper        | feh                                            |
| Theming          | Adwaita-dark (GTK 2/3/4, Qt via `gtk3` portal) |

Additional configured applications: cmus, cava, fastfetch.

## Layout

```
.
├── install.sh                       installer / updater
├── wallpapers/                      wallpapers synced into ~/Wallpapers
├── home/                            files installed into ~
│   ├── .local/bin/                  helper scripts           → ~/.local/bin
│   │   ├── setwall                  wallpaper restore/randomizer
│   │   ├── screenshot               region screenshot
│   │   └── volume                   volume control + on-screen popup
│   ├── .local/share/applications/
│   │   └── nvim.desktop             Neovim-in-Alacritty wrapper (Terminal=false)
│   ├── .xinitrc                     X session startup        → ~/.xinitrc
│   ├── .zshrc                       shell configuration      → ~/.zshrc
│   ├── .gitconfig                   global git configuration → ~/.gitconfig
│   └── gtkrc-2.0                    GTK2 dark theme          → ~/.gtkrc-2.0
├── vxwm/
│   └── config.h                     vxwm build-time configuration
├── ly/
│   └── config.ini                   ly display manager config → /etc/ly/config.ini
├── x11/
│   └── 30-libinput.conf             mouse/touchpad settings   → /etc/X11/xorg.conf.d/
└── config/                          mirrored into ~/.config
    ├── mimeapps.list                default app associations  → ~/.config/mimeapps.list
    ├── alacritty/
    ├── git/                         global git ignore        → ~/.config/git/ignore
    ├── nvim/
    ├── picom/
    ├── rofi/
    ├── dunst/
    ├── quickshell/
    ├── yazi/
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

- Input settings live in `x11/30-libinput.conf`, installed to
  `/etc/X11/xorg.conf.d/30-libinput.conf`: keyboard layout (`us,ru` toggled with
  `Caps Lock`), mouse and touchpad sensitivity, acceleration profile,
  tap-to-click, and scrolling. Because these are declarative they apply before
  login, so the ly greeter honours the layout too. Edit the options there (each
  is documented inline) and re-run the installer (or `--skip-deps`) to apply;
  probe live values with `xinput list-props <id>`. The one input setting that
  has no reliable libinput equivalent — keyboard auto-repeat — stays in
  `.xinitrc` as `xset r rate 250 50` (250 ms delay, 50 Hz).
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
- The status bar is [Quickshell](https://quickshell.outfoxxed.me/), started from
  `.xinitrc` and configured in `~/.config/quickshell/` (gruvbox dark, matching
  the rest of the rice) with a fully transparent background — picom composites it
  over the wallpaper, and every glyph carries a soft blurred drop shadow so the
  text stays readable on light wallpapers. Left: tags 1–9 — the focused one is
  read live from vxwm's `_NET_CURRENT_DESKTOP` (EWMH) and clicking a tag replays
  the `Super+N` view keybind via xdotool (the active tag gets a solid accent
  plate, the rest are plain foreground). Centre: a minute-precision clock. Right,
  left to right: a collapsible StatusNotifier system tray hidden behind a chevron
  (click to reveal the icons), the active keyboard layout (`US`/`RU`, click
  toggles it by sending `Caps_Lock`), then speaker volume (click toggles mute,
  scroll adjusts ±5%, turns red when muted) and microphone state (red when muted,
  click toggles). vxwm's internal bar is left off (`showbar = 0`); Quickshell
  reserves the strut so windows tile below it. Quickshell and the
  `xkblayout-state` helper (used by the layout indicator to read the active XKB
  group) are **not** in the official repos, so the installer bootstraps the
  `yay` AUR helper and pulls them in automatically; the Qt6 runtime they need
  (`qt6-base`, `qt6-declarative`, `qt6-svg`) comes from the official repos. The
  tag readout relies on vxwm's `EWMH_TAGS` module and the strut on
  `EXTERNAL_BARS`, both enabled by default in vxwm's `modules.def.h`.
- Application launch keys: `Super+Return` opens Alacritty, `Super+D` the rofi
  launcher (drun mode, gruvbox dark — config in `~/.config/rofi`), `Super+W`
  Chromium, `Super+E` Thunar, and `Super+O` Obsidian.
- The Qt platform theme is forced to `gtk3` so Qt apps follow the GTK dark
  theme.
- Default applications are set in `~/.config/mimeapps.list`, read by
  `xdg-open` and Thunar: Chromium for web pages and URLs, mupdf for PDF/EPUB,
  feh for images, VLC for audio, mpv for video, xarchiver for archives, Neovim
  for text/scripts/code, and Thunar for directories. These mirror the openers
  in `~/.config/yazi/yazi.toml`, so files open the same way from yazi, Thunar,
  or any app that calls `xdg-open`.
- Text files and scripts open in Neovim via a custom
  `~/.local/share/applications/nvim.desktop` wrapper that runs `alacritty -e
  nvim` with `Terminal=false`. This overrides the stock `nvim.desktop` (whose
  `Terminal=true` makes Thunar fail with "Unable to find terminal required for
  application" on this non-XFCE setup, since there is no preferred-terminal
  helper to resolve).
- Removable drives are auto-mounted by `udiskie` (started from `.xinitrc`),
  which sits on top of `udisks2` and notifies on insert/remove via dunst.
  Mounted media show up under `/run/media/$USER` and in Thunar; right-click a
  device there to unmount.
- `.zshrc` provides two yt-dlp wrappers: `getaudio <url>` extracts audio as
  mp3 into `~/Music/Downloads`, and `getvideo <url>` downloads best
  video+audio into `~/Videos/Downloads`.
- The CLI file manager is yazi. Run it with `y`, a wrapper that quits into the
  directory you last browsed (press `q` to quit, `Q` to quit without cd'ing).
  Its openers live in `~/.config/yazi/yazi.toml` and mirror the routing in
  `~/.config/mimeapps.list`.
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
