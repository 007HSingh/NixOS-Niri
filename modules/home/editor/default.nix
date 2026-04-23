# Neovim Editor
# Package, Treesitter grammars, and config/ symlink wiring
# Lua config lives in config/neovim/ — do not move it; only the symlink is managed here
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.editor;
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  options.modules.home.editor.enable =
    lib.mkEnableOption "neovim editor with Treesitter grammars and config symlink";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim

      # ── Treesitter grammars (Telescope, DAP, etc.) ───────────────────────────
      (vimPlugins.nvim-treesitter.withPlugins (
        p: with p; [
          bash
          c
          cpp
          go
          lua
          python
          javascript
          typescript
          html
          css
          json
          yaml
          markdown
          vim
          vimdoc
          rust
          java
          nix
        ]
      ))
    ];

    # Symlink ~/.config/nvim → nixos-config/config/neovim (out-of-store, mutable)
    xdg.configFile.nvim = {
      source = create_symlink "${dotfiles}/neovim";
      recursive = true;
    };
  };
}
