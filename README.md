# ❄️ NixOS-Niri Configuration

A modular, state-of-the-art NixOS configuration built with **flake-parts**, featuring the **Niri** scrollable tiling compositor and a fully declarative system-wide theme.

<div align="center">

[![NixOS Version](https://img.shields.io/badge/NixOS-25.11-blue?logo=nixos&logoColor=white&style=for-the-badge)](https://nixos.org)
[![Compositor](https://img.shields.io/badge/WM-Niri-cba6f7?style=for-the-badge)](https://github.com/YaLTeR/niri)
[![Theme](https://img.shields.io/badge/Theme-Catppuccin_Mocha-f5c2e7?style=for-the-badge)](https://github.com/catppuccin/catppuccin)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

</div>

---

## ✨ Features

### 🖥️ Desktop Environment

- **Window Manager:** [Niri](https://github.com/YaLTeR/niri) — A scrollable tiling Wayland compositor that treats windows as a long ribbon.
- **Status Bar:** [Noctalia](https://github.com/noctalia-dev/noctalia-shell) — A modern Wayland shell/status bar with rich plugin support.
- **Shell Components:** [Quickshell](https://github.com/outfoxxed/quickshell) — Custom-built Wayland UI components (Wallpaper picker, etc.).
- **Display Manager:** [ly](https://github.com/fairyglade/ly) — A lightweight TUI display manager with a Matrix-style animation.

### 🎨 Theming & Aesthetics

- **Foundation:** [Stylix](https://github.com/danth/stylix) — The single source of truth for system-wide colors, fonts, and wallpapers.
- **Palette:** [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) — A soothing, high-contrast dark theme applied to everything.
- **Fonts:** [Maple Mono NF](https://github.com/subframe7k/maple-font) for terminal, [Nunito](https://github.com/googlefonts/nunito) for UI.
- **Music:** [Spicetify](https://github.com/Gerg-L/spicetify-nix) — Declarative Spotify theming.

### 🛠️ Development & Tools

- **IDE:** [Visual Studio Code](https://code.visualstudio.com/) — Fully configured via Home Manager with Catppuccin Mocha and language-specific extensions.
- **CLI Editor:** [Neovim](https://neovim.io/) — A powerful terminal-based editor for quick edits and heavy CLI work.
- **Browser:** [Zen Browser](https://github.com/0xc000022070/zen-browser-flake) — A Firefox-based browser focused on privacy and vertical tabs.
- **AI Integration:** [Claude Code](https://github.com/sadjow/claude-code-nix)
- **Secrets:** [sops-nix](https://github.com/Mic92/sops-nix) — Secure secret management using SOPS.

---

## 🏗️ Architecture

This repository follows a modular structure using `flake-parts` for a clean separation of concerns. All NixOS and Home Manager modules live under `modules/` and are **automatically discovered** via [`import-tree`](https://github.com/vic/import-tree) — no manual import lists to maintain.

```bash
nixos-config/
├── ❄️ flake.nix             # Entrypoint & inputs management
├── 🧱 nix/                  # Flake build logic & profiles
│   ├── lib.nix              # mkHost builder
│   ├── nixos.nix            # Host registration (lib.mkHost)
│   ├── modules.nix          # Module discovery via import-tree
│   ├── dev.nix              # Dev shell (statix, deadnix, nh, sops…)
│   ├── treefmt.nix          # Unified formatting (nixfmt, stylua, prettier)
│   └── profiles/
│       ├── predator.nix     # Enables system modules for the predator host
│       └── harsh.nix        # Enables home modules for the harsh user
├── 🖥️ hosts/                # Per-machine configurations
│   └── predator/            # Acer Predator (Intel i7 + NVIDIA RTX 4050)
│       ├── default.nix      # Machine identity & host-specific packages
│       └── hardware.nix     # Generated hardware configuration
├── ⚙️ modules/              # All reusable NixOS & Home Manager modules
│   ├── system/              # System-level NixOS modules (auto-discovered)
│   │   ├── boot.nix         # GRUB, Plymouth, zram swap
│   │   ├── desktop.nix      # Niri compositor, ly DM, PipeWire, XDG portals
│   │   ├── fonts.nix        # System font packages
│   │   ├── hardware.nix     # Hardware enablement
│   │   ├── networking.nix   # Network configuration
│   │   ├── nix.nix          # Nix daemon & store settings
│   │   ├── nvidia.nix       # NVIDIA drivers + Prime sync
│   │   ├── packages.nix     # System-wide packages
│   │   ├── programs.nix     # System programs
│   │   ├── security.nix     # Security & PAM configuration
│   │   ├── services.nix     # System services
│   │   ├── stylix.nix       # Catppuccin Mocha theme (colors, fonts, wallpaper)
│   │   └── users.nix        # User account definitions
│   └── home/                # Home Manager modules (auto-discovered)
│       ├── browser.nix      # Zen Browser configuration
│       ├── clipboard.nix    # Clipboard manager
│       ├── git.nix          # Git identity & settings
│       ├── media.nix        # Media players
│       ├── neovim.nix       # Neovim configuration
│       ├── noctalia.nix     # Noctalia status bar
│       ├── packages.nix     # CLI tools, LSP servers, formatters, linters
│       ├── shell.nix        # Zsh, Starship, Atuin, Zoxide, Yazi, etc.
│       ├── termipedia/      # Terminal encyclopaedia tool (multi-file)
│       ├── theming.nix      # GTK/QT theming compatibility shim
│       ├── utilities.nix    # Utility tools
│       ├── wofi.nix         # Application launcher
│       ├── xdg.nix          # XDG dirs & dotfile symlinks
│       └── zathura.nix      # PDF viewer
├── 👤 users/
│   └── harsh.nix            # User identity, SOPS config & stateVersion
├── 📂 dotfiles/             # Raw config files symlinked into ~/.config/
│   ├── niri/                # Niri compositor config (KDL format)
│   ├── neovim/              # Neovim (vanilla lazy.nvim, NOT nixvim)
│   ├── noctalia/            # Noctalia config
│   └── wallpapers/          # Wallpaper collection
└── 🔐 secrets/              # Encrypted secrets via SOPS + age
```

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/007HSingh/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

### 2. Build and Switch

To apply the configuration to the **predator** host:

```bash
sudo nixos-rebuild switch --flake .#predator
```

### 3. Daily Commands

The config includes several handy aliases for system maintenance:

- `update`: Runs `nh os switch` to rebuild and switch the system.
- `home-update`: Runs `nh home switch` to rebuild the Home Manager environment.
- `y`: Opens Yazi (TUI file manager) and `cd`s into the last directory on exit.

---

## 🛠️ Extending the Config

### Adding a New Machine

1. Create `hosts/<name>/default.nix` with machine identity and `hosts/<name>/hardware.nix`.
2. Create `nix/profiles/<name>.nix` enabling the desired system modules via `modules.system.<module>.enable = true`.
3. Register the host in `nix/nixos.nix` using `lib.mkHost`.

### Adding a System Module

1. Create `modules/system/<name>.nix` following the existing pattern:
   - Declare `options.modules.system.<name>.enable = lib.mkEnableOption "…";`
   - Guard everything with `config = lib.mkIf cfg.enable { … };`
2. **No import needed** — `import-tree` discovers it automatically.
3. Enable it in `nix/profiles/predator.nix`.

### Adding a Home Module

1. Create `modules/home/<name>.nix` following the same pattern:
   - Declare `options.modules.home.<name>.enable = lib.mkEnableOption "…";`
2. **No import needed** — `import-tree` discovers it automatically.
3. Enable it in `profiles/harsh.nix` (or the relevant user profile).

### Editing Dotfiles

Edit files under `dotfiles/` directly — they are symlinked from `~/.config/` via `modules/home/xdg.nix`. Changes take effect immediately without a rebuild.

---

## 📝 License

This project is licensed under the **MIT License**.
Built with ❤️ and **NixOS 25.11**.
