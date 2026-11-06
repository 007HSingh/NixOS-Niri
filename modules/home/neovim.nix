{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.neovim;
  pythonWithDebugpy = pkgs.python3.withPackages (pythonPackages: [ pythonPackages.debugpy ]);
in
{
  options.modules.home.neovim.enable = lib.mkEnableOption "neovim editor";

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      sideloadInitLua = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = false;
      withRuby = false;

      extraPackages = with pkgs; [
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
        typescript-language-server
        lemminx

        nixfmt
        stylua
        shfmt
        kdlfmt
        ruff
        prettier
        google-java-format
        luajitPackages.luacheck
        shellcheck
        markdownlint-cli2
        statix
        deadnix
        eslint_d

        tree-sitter
      ];
    };

    home.sessionVariables = {
      DEBUGPY_PATH = "${pythonWithDebugpy}/bin/python";
      CODELLDB_PATH = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
      LOMBOK_JAR = "${pkgs.lombok}/share/java/lombok.jar";
      JAVA_DEBUG_DIR = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
    };
  };
}
