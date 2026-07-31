# Neovim
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.neovim;
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
      shfmt
      kdlfmt

      # Linters
      luajitPackages.luacheck
      shellcheck
      markdownlint-cli2
      statix
      deadnix
      tree-sitter
    ];
  };
}
