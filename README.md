# Arch Linux + Hyprland dotfiles

An opinionated, symlink-managed desktop configuration for Arch Linux. The setup combines
Hyprland's Lua configuration with Ghostty, Neovim, Fastfetch, Hyprpaper, and an optional Gmail
sync loop.

> [!WARNING]
> These are personal dotfiles, not a general-purpose distribution. Review the monitor, GPU,
> autostart, and keybinding settings before using them on another machine.

## Highlights

- **Hyprland:** animated dwindle layout, workspace controls, media keys, and machine-local
  monitor/GPU overrides
- **Ghostty:** Catppuccin Mocha, transparent background, JetBrains Mono Nerd Font, and an
  animated cursor shader
- **Neovim:** lazy.nvim, Catppuccin, blink.cmp, Telescope with native FZF, Treesitter,
  mini.pairs, and lualine
- **Fastfetch:** compact, color-coded system summary
- **Mail:** optional Gmail synchronization through isync/mbsync with credentials stored in the
  system keyring
- **Tooling:** EditorConfig, StyLua, shfmt, ShellCheck, a local check script, and GitHub Actions

## Repository layout

```text
.
├── fastfetch/                 # Fastfetch JSONC configuration
├── ghostty/                   # Terminal configuration and vendored cursor shader
├── hypr/                      # Hyprland, Hyprpaper, local template, and wallpaper
├── mbsync/                    # Mail sync script and credential-free config template
├── nvim/                      # Neovim configuration and lazy.nvim lockfile
├── scripts/                   # Validation and dependency update helpers
├── .editorconfig
├── .gitattributes
├── .gitignore
├── install.sh
├── stylua.toml
└── README.md
```

## Requirements

This repository follows current Arch packages and is tested with Hyprland 0.56, Hyprpaper 0.8,
Ghostty 1.3, and Neovim 0.12. Hyprland 0.55 or newer is required because the compositor config
uses the Lua API.

Install the main packages with:

```bash
sudo pacman -S --needed \
  base-devel brightnessctl fastfetch fd ghostty git hyprland hyprlauncher \
  hyprpaper hyprpolkitagent mako neovim playerctl ripgrep \
  thunar ttf-jetbrains-mono-nerd waybar
```

For mail synchronization, also install:

```bash
sudo pacman -S --needed isync libsecret
```

`wpctl`, used by the volume keybindings, is provided by WirePlumber. Telescope's native sorter
requires `make` and a C compiler, both supplied by `base-devel`.

## Installation

Clone the repository and run the installer as your normal user:

```bash
git clone https://github.com/Hiyabye/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer creates these links:

| Repository path | Destination |
| --- | --- |
| `fastfetch/` | `${XDG_CONFIG_HOME:-~/.config}/fastfetch` |
| `ghostty/` | `${XDG_CONFIG_HOME:-~/.config}/ghostty` |
| `hypr/` | `${XDG_CONFIG_HOME:-~/.config}/hypr` |
| `nvim/` | `${XDG_CONFIG_HOME:-~/.config}/nvim` |
| `mbsync/mail-sync.sh` | `~/.local/bin/mail-sync` |
| `mbsync/mbsyncrc` | `~/.mbsyncrc` when the local file exists |

Existing paths are never silently overwritten. Conflicts are skipped and make the installer
exit unsuccessfully. To move each conflict to a timestamped backup and continue, run:

```bash
./install.sh --force
```

After installation, open Neovim. lazy.nvim will install the locked plugins on first launch.
Run `:checkhealth` when setup is complete.

## Machine-local configuration

The tracked defaults are portable where practical. Keep hardware details and credentials in
ignored local files:

### Hyprland

```bash
cp hypr/local.lua.example hypr/local.lua
```

Edit the copy to define monitor settings, NVIDIA/DRM variables, and optional mail autostart.
Without it, Hyprland uses a preferred-mode fallback monitor and no vendor-specific GPU settings.

### Ghostty

Create `ghostty/local.ghostty` for settings that should not be published. It is loaded after the
tracked config, so its values take precedence.

### Neovim

Create `nvim/lua/config/local.lua`. Neovim loads it after the shared configuration when present.

## Optional Gmail sync

Never place a password or app password directly in an mbsync configuration.

1. Create the ignored local config and replace `you@example.com`:

   ```bash
   cp mbsync/mbsyncrc.example mbsync/mbsyncrc
   chmod 600 mbsync/mbsyncrc
   ```

2. Store a Gmail app password in the desktop keyring:

   ```bash
   secret-tool store --label='mbsync Gmail' service mbsync account gmail
   ```

3. Re-run `./install.sh` to link the config, then test one synchronization:

   ```bash
   mail-sync --once
   ```

4. Set `start_mail_sync = true` in `hypr/local.lua` to start the loop with Hyprland.

The loop runs every 60 seconds by default. Override this with `MAIL_SYNC_INTERVAL`. An optional
executable path in `MAIL_SYNC_HOOK` runs after each attempt.

Gmail folder names can be localized. Adjust `Patterns` in the local mbsync config if `INBOX` is
not the desired folder.

## Keybindings

### Hyprland

| Binding | Action |
| --- | --- |
| `Super + Q` | Open Ghostty |
| `Super + C` | Close the active window |
| `Super + M` | Exit Hyprland |
| `Super + E` | Open Thunar |
| `Super + R` | Open Hyprlauncher |
| `Super + V` | Toggle floating mode |
| `Super + P` | Toggle pseudo-tiling |
| `Super + J` | Toggle the dwindle split |
| `Super + Arrow` | Move focus |
| `Super + 0-9` | Switch workspace |
| `Super + Shift + 0-9` | Move the active window to a workspace |
| `Super + S` | Toggle the `magic` scratchpad |
| `Super + drag` | Move or resize a window |

Volume, microphone, brightness, and media hardware keys are also configured.

### Neovim

| Binding | Action |
| --- | --- |
| `Ctrl + S` | Save |
| `Ctrl + Q` | Quit |
| `Ctrl + E` | Find files with Telescope |
| `Ctrl + F` | Search text with Telescope |
| `Ctrl + T` | Open a tab |
| `Ctrl + F4` | Close a tab |
| `Ctrl + A/C/X/V/Z/Y` | GUI-style select, clipboard, undo, and redo actions |

Native `Ctrl + W` window commands remain available.

## Validation and maintenance

Install the portable validation tools and run every available local check with:

```bash
sudo pacman -S --needed jq lua shellcheck shfmt stylua
./scripts/check.sh
```

The script validates formatting, Lua and JSON syntax, shell code, trailing whitespace, and—when
installed—the application configurations. Missing optional validators are reported as skipped.
GitHub Actions runs the portable static checks on pushes and pull requests.

To refresh the vendored Ghostty cursor shader and its license from upstream:

```bash
./scripts/update-cursor-shader.sh
```

The updater requires `curl` or `wget`. Review the resulting diff before committing. Keep
`nvim/lazy-lock.json` committed to preserve
reproducible plugin versions.

## Third-party notice

`ghostty/shaders/cursor_warp.glsl` comes from
[sahaj-b/ghostty-cursor-shaders](https://github.com/sahaj-b/ghostty-cursor-shaders). It is
redistributed under the MIT License; the required notice is stored in
[`ghostty/shaders/LICENSE`](ghostty/shaders/LICENSE).
