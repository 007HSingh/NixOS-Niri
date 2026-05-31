# Emacs + Doom Emacs - organisation-focused setup
{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.home.emacs;
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  options.modules.home.emacs.enable = lib.mkEnableOption "Emacs with Doom";

  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;

      extraPackages = epkgs: [
        epkgs.vterm

        (epkgs.treesit-grammars.with-grammars (
          grammars: with grammars; [
            tree-sitter-nix
            tree-sitter-lua
            tree-sitter-python
            tree-sitter-bash
            tree-sitter-org
            tree-sitter-markdown
            tree-sitter-yaml
            tree-sitter-json
            tree-sitter-java
          ]
        ))
      ];
    };

    services.emacs = {
      enable = true;
      client.enable = true;
    };

    home.packages = with pkgs; [
      sqlite
      pandoc

      (aspellWithDicts (ds: with ds; [ en ]))

      texlive.combined.scheme-medium

      (writeShellScriptBin "doom-sync" ''
        export PATH="${pkgs.git}/bin:${pkgs.ripgrep}/bin:${pkgs.fd}/bin:$PATH"
        exec "$HOME/.config/emacs/bin/doom" sync "$@"
      '')

      (writeShellScriptBin "e" ''
        exec emacsclient --no-wait "$@"
      '')
    ];

    xdg.configFile."doom" = {
      source = create_symlink "${dotfiles}/emacs";
      recursive = true;
    };

    home.sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      EMACSDIR = "${config.home.homeDirectory}/.config/emacs";
      GTK_IM_MODULE = "ibus";
    };
  };
}
