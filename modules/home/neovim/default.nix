# Neovim
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
      qt6.qtdeclarative

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
      ripgrep
      fd
      nodejs
      tree-sitter

      # DAP
      python314Packages.debugpy
      vscode-extensions.vadimcn.vscode-lldb
      vscode-js-debug
      vscode-extensions.vscjava.vscode-java-debug
    ];

    # out-of-store symlink so Lua config stays mutable
    xdg.configFile.nvim = {
      source = create_symlink "${dotfiles}/neovim";
      recursive = true;
    };

    home.sessionVariables = {
      CODELLDB_PATH = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
      VSCODE_JS_DEBUG_PATH = "${pkgs.vscode-js-debug}/lib/node_modules/@vscode/js-debug/src/dapDebugServer.js";
      JAVA_DEBUG_JAR = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-0.53.2.jar";
      DEBUGPY_PATH = "${pkgs.python314Packages.debugpy}/${pkgs.python314.sitePackages}/debugpy";
    };
  };
}
