# NixOS Configuration — Claude Code Context

## Architecture
- **Framework**: flake-parts
- **Host**: predator (Acer Predator, Intel i7 + NVIDIA RTX 4050, Prime sync)
- **Channel**: nixos-unstable (nixpkgs-unstable)
- **User**: harsh

## Directory Layout
- flake.nix — inputs and entrypoint
- parts/ — flake outputs (nixos.nix, dev.nix, treefmt.nix)
- system/ — NixOS system modules shared across hosts
- home/ — Home Manager modules shared across users
- users/harsh/ — user entry point, imports ../../home
- hosts/predator/ — machine-specific config + hardware.nix
- lib/default.nix — mkHost helper function
- config/ — dotfiles symlinked via home/xdg.nix (edit here directly)
- secrets/ — sops-nix + age encrypted secrets

## Config Symlinks (edit files in config/, not ~/.config/)
- config/niri/ — Niri compositor (KDL format)
- config/kitty/ — Kitty terminal
- config/neovim/ — Neovim (vanilla lazy.nvim, NOT nixvim)
- config/btop/ — btop system monitor
- config/fastfetch/ — fastfetch
- config/eza/ — eza

## Stack
- WM: Niri (Wayland, scrollable tiling)
- Bar: Noctalia shell
- Terminal: Kitty (glassmorphism, 0.88 opacity)
- Shell: Zsh + Starship + Atuin + Zoxide
- Editor: Neovim (lazy.nvim)
- Theme: Catppuccin Mocha everywhere (Stylix system-wide)
- Browser: Zen Browser (Firefox-based)
- Secrets: sops-nix + age (key at ~/.config/sops/age/keys.txt)

## Rebuild Commands
- nh os switch — rebuild system (alias: update)
- nh home switch — rebuild home (alias: home-update)
- nix flake check --no-build — validate
- nix fmt — format (nixfmt + stylua + prettier + shfmt)

## CI Checks (all must pass before committing)
- nix fmt -- --fail-on-change
- statix check .
- deadnix --no-lambda-arg --fail .
- nix flake check --no-build

## Hard Rules
- NEVER change system.stateVersion = "25.11" or home.stateVersion = "25.11"
- NVIDIA-specific config lives in hosts/predator/ only
- Neovim is configured via vanilla lua in config/neovim/, not nixvim
- Always run nix fmt after editing .nix files
- statix disabled warnings: empty_pattern, repeated_keys (see statix.toml)

## Adding New Packages
- User CLI tools → home/packages.nix
- System-wide apps → system/packages.nix
- New HM modules → home/ + add import to home/default.nix
- New system modules → system/ + add import to system/default.nix

## Adding a New Host
1. Create hosts/<name>/default.nix and hosts/<name>/hardware.nix
2. Register in parts/nixos.nix using lib.mkHost

## Neovim Plugin Changes
- Edit files under config/neovim/lua/plugins/
- lazy-lock.json tracks pinned commits — run :Lazy sync inside Neovim to update
- LSP servers and formatters are managed via Mason + conform.nvim in config/neovim/lua/plugins/lsp.lua
- Nix packages for LSP/formatters are also declared in home/packages.nix (both must stay in sync)
