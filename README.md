# dotfiles

Symlinked configuration for Ghostty and Neovim.

```
~/dotfiles/ghostty -> ~/.config/ghostty
~/dotfiles/nvim    -> ~/.config/nvim
```

Edit files here; apps read them through the symlinks. Generated data,
plugins, and machine-local overrides stay out of Git.

## Install

```sh
git clone https://github.com/Hiyabye/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer never overwrites existing configs — back up or remove
`~/.config/ghostty` and `~/.config/nvim` first if needed. Open Neovim after
installing; lazy.nvim and Mason pull in plugins and language servers.

## Machine-local overrides

Optional, loaded automatically, ignored by Git:

- `ghostty/local.ghostty`
- `nvim/lua/config/local.lua`

## Shader

`ghostty/shaders/cursor_warp.glsl` (referenced in `config.ghostty`) is from
[sahaj-b/ghostty-cursor-shaders](https://github.com/sahaj-b/ghostty-cursor-shaders) (MIT).
`update.sh` refreshes it.
