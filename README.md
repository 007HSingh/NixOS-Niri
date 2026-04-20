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
- **Fonts:** [Maple Mono NF](https://github.com/subframe7k/maple-font) for terminal, [Inter](https://rsms.me/inter/) for UI.
- **Music:** [Spicetify](https://github.com/Gerg-L/spicetify-nix) — Declarative Spotify theming.

### 🛠️ Development & Tools

- **IDE:** [Visual Studio Code](https://code.visualstudio.com/) — Fully configured via Home Manager with Catppuccin Mocha and language-specific extensions.
- **CLI Editor:** [Neovim](https://neovim.io/) — A powerful terminal-based editor for quick edits and heavy CLI work.
- **Browser:** [Zen Browser](https://github.com/0xc000022070/zen-browser-flake) — A Firefox-based browser focused on privacy and vertical tabs.
- **AI Integration:** [Claude Code](https://github.com/sadjow/claude-code-nix) & [Antigravity](https://github.com/jacopone/antigravity-nix) for intelligent coding assistance.
- **Secrets:** [sops-nix](https://github.com/Mic92/sops-nix) — Secure secret management using SOPS.

---

## 🏗️ Architecture

This repository follows a modular structure using `flake-parts` for a clean separation of concerns.

```bash
nixos-config/
├── ❄️ flake.nix             # Entrypoint & inputs management
├── 🧱 parts/                # Flake outputs (host definitions, dev shells)
│   ├── nixos.nix            # Host registration logic
│   └── treefmt.nix          # Unified code formatting
├── 🖥️ hosts/                # Per-machine configurations
│   └── predator/            # Configuration for the Acer Predator laptop
├── ⚙️ system/               # System-wide NixOS modules
│   ├── desktop.nix          # Niri, SDDM, audio, and Wayland config
│   ├── stylix.nix           # Centralized theming (Colors, Fonts)
│   └── ...                  # Boot, Hardware, Networking, Security
├── 🏠 home/                 # User-level Home Manager modules
│   ├── noctalia.nix         # Status bar configuration
│   ├── vscode.nix           # VS Code extensions and settings
│   ├── shell.nix            # Zsh, Starship, and Aliases
│   └── ...                  # App configs (Firefox, Git, Obsidian)
├── 👤 users/                # User definitions & profiles
├── 📚 lib/                  # Custom helper functions (mkHost)
└── 🔐 secrets/              # Encrypted secrets via SOPS
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

- `update`: Syncs system with the flake.
- `clean`: Collects garbage and cleans up old generations.
- `edit`: Opens the config directory in your editor.

---

## 🛠️ Extending the Config

### Adding a New Machine

1. Create a new directory in `hosts/` and import your `hardware-configuration.nix`.
2. Add a host entry in `parts/nixos.nix` using the `lib.mkHost` helper.

### Adding a Module

1. Create the module in `system/` (for system-wide) or `home/` (for user-level).
2. Import it in the respective `default.nix` entrypoint.

---

## 📝 License

This project is licensed under the **MIT License**.
Built with ❤️ and **NixOS 25.11**.
