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
  cfg = config.modules.home.neovim;
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  options.modules.home.neovim.enable =
    lib.mkEnableOption "neovim editor with Treesitter grammars and config symlink";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim

      # LSP servers
      nixd
      lua-language-server
      typescript-language-server
      vscode-langservers-extracted # html, css, json, eslint
      yaml-language-server
      dockerfile-language-server
      docker-compose-language-service
      pyright
      rust-analyzer
      bash-language-server
      jdt-language-server
      clang-tools
      marksman

      # Formatters
      nixfmt
      stylua
      prettier
      black
      rustfmt
      shfmt
      kdlfmt
      google-java-format

      # Linters
      luajitPackages.luacheck
      shellcheck
      python314Packages.flake8
      eslint_d
      markdownlint-cli2
      statix

      # ── Neovim: CLI tools (Telescope, DAP, etc.) ─────────────────────────────
      ripgrep
      fd
      nodejs
      vimPlugins.treesitter-modules-nvim
    ];

    # Symlink ~/.config/nvim → nixos-config/config/neovim (out-of-store, mutable)
    xdg.configFile.nvim = {
      source = create_symlink "${dotfiles}/neovim";
      recursive = true;
    };
  };
}
