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
- **AI Integration:** [Claude Code](https://github.com/sadjow/claude-code-nix) & [Antigravity](https://github.com/jacopone/antigravity-nix) for intelligent coding assistance.
- **Secrets:** [sops-nix](https://github.com/Mic92/sops-nix) — Secure secret management using SOPS.

---

## 🏗️ Architecture

This repository follows a modular structure using `flake-parts` for a clean separation of concerns. All NixOS and Home Manager modules live under `modules/` and are **automatically discovered** via [`import-tree`](https://github.com/vic/import-tree) — no manual import lists to maintain.

```bash
nixos-config/
├── ❄️ flake.nix             # Entrypoint & inputs management
├── 🧱 parts/                # Flake outputs (host definitions, dev shells)
│   ├── nixos.nix            # Host registration logic (lib.mkHost)
│   ├── modules.nix          # Module discovery via import-tree
│   ├── dev.nix              # Development shell (statix, deadnix, nh, sops…)
│   └── treefmt.nix          # Unified code formatting (nixfmt, stylua, prettier)
├── 🖥️ hosts/                # Per-machine configurations
│   └── predator/            # Acer Predator laptop (Intel i7 + NVIDIA RTX 4050)
│       ├── default.nix      # Machine identity & host-specific packages
│       └── hardware.nix     # Generated hardware configuration
├── ⚙️ modules/              # All reusable NixOS & Home Manager modules
│   ├── system/              # System-level NixOS modules (auto-discovered)
│   │   ├── boot/            # GRUB, Plymouth, zram swap
│   │   ├── desktop/         # Niri compositor, ly DM, PipeWire, XDG portals
│   │   ├── fonts/           # System font packages
│   │   ├── hardware/        # Hardware enablement
│   │   ├── networking/      # Network configuration
│   │   ├── nix/             # Nix daemon & store settings
│   │   ├── nvidia/          # NVIDIA drivers + Prime sync
│   │   ├── packages/        # System-wide packages
│   │   ├── programs/        # System programs
│   │   ├── security/        # Security & PAM configuration
│   │   ├── services/        # System services
│   │   ├── stylix/          # Catppuccin Mocha theme (colors, fonts, wallpaper)
│   │   ├── users/           # User account definitions
│   │   └── vm/              # Virtualisation support
│   └── home/                # Home Manager modules (auto-discovered)
│       ├── audio/           # Audio tools (EasyEffects, etc.)
│       ├── bar/             # Noctalia status bar & plugins
│       ├── browser/         # Zen Browser configuration
│       ├── clipboard/       # Clipboard manager
│       ├── editor/          # Neovim + Treesitter grammars
│       ├── git/             # Git identity & settings
│       ├── idle/            # Idle inhibitor (hypridle)
│       ├── media/           # Media players
│       ├── notes/           # Obsidian
│       ├── packages/        # CLI tools, LSP servers, formatters, linters
│       ├── quickshell/      # Quickshell (wallpaper picker & shell widgets)
│       ├── shell/           # Zsh, Starship, Atuin, Zoxide, Yazi, etc.
│       ├── termipedia/      # Terminal encyclopaedia tool
│       ├── theming/         # GTK/QT theming compatibility shim
│       ├── vscode/          # VS Code extensions & settings
│       ├── wofi/            # Application launcher
│       └── xdg/             # XDG dirs & dotfile symlinks
├── 🗂️ profiles/             # Module enablement profiles (what each host/user uses)
│   ├── predator.nix         # Enables all system modules for the predator host
│   └── harsh.nix            # Enables all home modules for the harsh user
├── 👤 users/                # User entry points (identity, SOPS, stateVersion)
│   └── harsh/
├── 📂 config/               # Dotfiles — symlinked into ~/.config/, edit here directly
│   ├── niri/                # Niri compositor config (KDL format)
│   ├── kitty/               # Kitty terminal
│   ├── neovim/              # Neovim (vanilla lazy.nvim, NOT nixvim)
│   ├── btop/                # btop system monitor
│   ├── fastfetch/           # fastfetch
│   ├── eza/                 # eza file listing
│   ├── noctalia/            # Noctalia custom plugins
│   └── quickshell/          # Quickshell components (wallpaper picker)
├── 📚 lib/                  # Custom helper functions
│   └── default.nix          # mkHost builder
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
2. Create `profiles/<name>.nix` enabling the desired system modules via `modules.system.<module>.enable = true`.
3. Register the host in `parts/nixos.nix` using `lib.mkHost`.

### Adding a System Module

1. Create a directory under `modules/system/<name>/default.nix` following the existing pattern:
   - Declare `options.modules.system.<name>.enable = lib.mkEnableOption "…";`
   - Guard everything with `config = lib.mkIf cfg.enable { … };`
2. **No import needed** — `import-tree` discovers it automatically.
3. Enable it in `profiles/predator.nix` (or the relevant host profile).

### Adding a Home Module

1. Create a directory under `modules/home/<name>/default.nix` following the same pattern:
   - Declare `options.modules.home.<name>.enable = lib.mkEnableOption "…";`
2. **No import needed** — `import-tree` discovers it automatically.
3. Enable it in `profiles/harsh.nix` (or the relevant user profile).

### Editing Dotfiles

Edit files under `config/` directly — they are symlinked from `~/.config/` via `modules/home/xdg/`. Changes take effect immediately without a rebuild.

---

## 📝 License

This project is licensed under the **MIT License**.
Built with ❤️ and **NixOS 25.11**.
