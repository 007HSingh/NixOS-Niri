# NixOS Configuration

A modular, scalable NixOS configuration built with **flake-parts**.

## 🏗️ Architecture

This repository uses a clean separation of concerns provided by the `flake-parts` framework:

```
nixos-config/
├── ❄️ flake.nix             # Entrypoint & inputs
├── 🧱 parts/                # Flake outputs (nixosConfigurations, devShells)
│   └── nixos.nix            # Host definitions
├── 🖥️ hosts/                # Per-machine configurations
│   └── nixos/               # Primary laptop config
├── ⚙️ system/               # NixOS system modules (shared)
│   ├── desktop.nix          # Niri, SDDM, audio
│   └── ...
├── 🏠 home/                 # Home Manager modules (shared)
│   ├── nixvim/              # Neovim configuration
│   └── ...
├── 👤 users/                # User definitions
│   └── harsh/               # Primary user profile
└── 📚 lib/                  # Helper functions (mkHost)
```

## 🚀 Usage

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/007HSingh/nixos-config.git ~/nixos-config
   cd ~/nixos-config
   ```

2. **Build & Switch:**
   ```bash
   # For the 'nixos' host
   sudo nixos-rebuild switch --flake .#nixos
   ```

### Daily Operations

- **Update System:**

  ```bash
  update  # Alias for sudo nixos-rebuild switch --flake ...
  ```

- **Update Flake Inputs:**

  ```bash
  nix flake update
  ```

- **Clean Garbage:**
  ```bash
  clean   # Alias for sudo nix-collect-garbage -d
  ```

## ✨ Features

- **Display Manager:** [ly](https://github.com/fairyglade/ly) (TUI with Matrix animation)
- **Window Manager:** [Niri](https://github.com/YaLTeR/niri) (Scrollable Tiling Wayland Compositor)
- **Shell:** [Noctalia](https://github.com/noctalia-dev/noctalia-shell) / Zsh + Starship
- **Editor:** Neovim (via [Nixvim](https://github.com/nix-community/nixvim))
- **Theme:** [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) (System-wide)
- **Browser:** Firefox
- **Gaming:** Steam, Gamemode

## 🛠️ Extending

### Adding a New Host

1. Create `hosts/<new-host>/default.nix` (importing hardware config).
2. Register it in `parts/nixos.nix` using `lib.mkHost`.

### Adding a New Module

1. Create the module in `system/` (NixOS) or `home/` (Home Manager).
2. Add it to the `imports` list in `system/default.nix` or `home/default.nix`.

## 📝 License

Configured for **NixOS 25.11**.
