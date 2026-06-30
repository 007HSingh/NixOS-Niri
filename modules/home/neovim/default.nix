# Neovim
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.neovim;

  javaDebugServerDir = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
  javaDebugJar = builtins.head (
    builtins.filter (x: lib.hasSuffix ".jar" (baseNameOf x)) (
      lib.filesystem.listFilesRecursive javaDebugServerDir
    )
  );
in
{
  options.modules.home.neovim.enable =
    lib.mkEnableOption "neovim editor with Treesitter grammars and config symlink";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
      rustc
      cargo

      # LSP servers
      nixd
      lua-language-server
      yaml-language-server
      dockerfile-language-server
      docker-compose-language-service
      pyright
      rust-analyzer
      bash-language-server
      jdt-language-server
      clang-tools
      marksman
      taplo

      # Formatters
      nixfmt
      stylua
      prettier
      rustfmt
      shfmt
      kdlfmt
      google-java-format

      # Linters
      luajitPackages.luacheck
      shellcheck
      ruff
      eslint_d
      markdownlint-cli2
      statix
      deadnix
      ripgrep
      fd
      nodejs
      tree-sitter

      # DAP
      python314Packages.debugpy
      vscode-extensions.vadimcn.vscode-lldb
      vscode-extensions.vscjava.vscode-java-debug

      # Testing
      vscode-extensions.vscjava.vscode-java-test

      lombok
    ];

    home.sessionVariables = {
      CODELLDB_PATH = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
      VSCODE_JS_DEBUG_PATH = "${pkgs.vscode-js-debug}/lib/node_modules/@vscode/js-debug/src/dapDebugServer.js";
      JAVA_DEBUG_JAR = "${javaDebugJar}";
      DEBUGPY_PATH = "${(pkgs.python314.withPackages (ps: [ ps.debugpy ]))}/bin/python3";
      JAVA_TEST_JAR = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
      LOMBOK_JAR = "${pkgs.lombok}/share/java/lombok.jar";
      GOOGLE_JAVA_STYLE = "${pkgs.google-java-format}";
    };
  };
}
