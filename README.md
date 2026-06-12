# Dotfiles

Small, symlink-based configuration for Ghostty and Neovim.

## How It Works

This repository is source of truth. Each application directory has same shape
as its directory under `~/.config`:

```text
~/dotfiles/ghostty  -> ~/.config/ghostty
~/dotfiles/nvim     -> ~/.config/nvim
```

Edit files in this repository. Applications read them through symlinks.
Generated data, plugins, caches, and credentials stay outside Git.

## Structure

```text
.
|-- ghostty/
|   |-- config.ghostty          # Terminal settings
|   `-- shaders/
|       `-- cursor.glsl         # Active cursor shader
|-- nvim/
|   |-- init.lua                # Loads core config, plugins, local overrides
|   |-- lazy-lock.json          # Pinned plugin versions
|   `-- lua/
|       |-- config/
|       |   |-- autocmds.lua    # Automatic editor actions
|       |   |-- keymaps.lua     # Global key mappings
|       |   |-- lazy.lua        # Plugin manager bootstrap
|       |   `-- options.lua     # Core editor options
|       `-- plugins/            # Plugins grouped by functionality
|           |-- ai.lua          # AI-assisted tools
|           |-- coding.lua      # Completion, LSP, formatting, and syntax
|           |-- ui.lua          # Theme, navigation, and interface helpers
|           `-- custom/
|               `-- jungol.lua  # Personal Jungol workflow
|-- .editorconfig               # Basic formatting rules
|-- .gitignore                  # Local and generated files
`-- install.sh                  # Creates configuration symlinks
```

## Requirements

- Git
- Ghostty 1.2.3+
- Neovim 0.11+
- Fira Code and D2Coding fonts
- `ripgrep` for Telescope text search
- `make` and a C compiler for Telescope's native sorter

Optional Neovim formatters:

- Lua: `stylua`
- C/C++: `clang-format`
- Python: `black`
- JavaScript, TypeScript, JSON, Markdown: `prettier`

GitHub Copilot also requires a subscription and `:Copilot setup`.

## Install

```sh
git clone https://github.com/Hiyabye/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Installer never replaces existing configuration. Back up or remove
`~/.config/ghostty` and `~/.config/nvim` first when needed.

Open Neovim after installation. lazy.nvim installs plugins; Mason installs
configured language servers. Then run:

```vim
:checkhealth
```

## Machine-Local Settings

Keep machine-specific paths, experiments, and secrets out of Git.

- Ghostty: create `ghostty/local.ghostty`
- Neovim: create `nvim/lua/config/local.lua`

Both files are optional, loaded automatically, and ignored by Git.

## Cursor Shader

`ghostty/shaders/cursor.glsl` provides the cursor trail enabled in
`ghostty/config.ghostty`.

Source:
[sahaj-b/ghostty-cursor-shaders](https://github.com/sahaj-b/ghostty-cursor-shaders)

Upstream license: MIT

## Maintenance

- Change existing behavior in its functional plugin group.
- Add Neovim plugins to the appropriate `lua/plugins/<function>.lua` file.
- Keep personal plugins in separate files under `lua/plugins/custom/`.
- Keep `nvim/lazy-lock.json` committed for reproducible plugin versions.
- Review with `git diff`, then stage intentionally with `git add`.
- Never commit API keys, access tokens, private keys, or machine credentials.
