# VSCode Configuration
# Allows extension changes without root rebuilds
# Note: lib.mkForce used on userSettings to override Noctalia's vscode module defaults
{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.home.vscode;
in
{
  options.modules.home.vscode = {
    enable = lib.mkEnableOption "VSCode with extensions and settings";
    minimal = lib.mkEnableOption "ultra-minimalist UI" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;

      profiles.default = {
        extensions =
          with pkgs.vscode-extensions;
          [
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
            jnoortheen.nix-ide
            ms-python.vscode-pylance
            ms-python.python
            ms-python.debugpy
            ms-python.flake8
            ms-vscode.cpptools-extension-pack
            redhat.java
            vscjava.vscode-java-pack
            vscjava.vscode-spring-initializr
            ms-vscode-remote.remote-containers
            docker.docker
            ms-azuretools.vscode-docker
            eamodio.gitlens
            github.codespaces
            github.vscode-github-actions
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "vscode-containers";
              publisher = "ms-azuretools";
              version = "2.4.1";
              sha256 = "02zqkdxazzppmj7pg9g0633fn1ima2qrb4jpb6pwir5maljlj31v";
            }
            {
              name = "copilot-chat";
              publisher = "Github";
              version = "0.43.2026040204";
              sha256 = "sha256-f2sUK60j6r887xxGDpkG6/msrXe4tgWHN3Hcs4RaWEs=";
            }
          ];

        userSettings = lib.mapAttrs (_: lib.mkForce) (
          (lib.recursiveUpdate
            {
              "editor.fontFamily" = "'Maple Mono NF', monospace";
              "editor.fontSize" = 13;
              "editor.fontLigatures" = true;
              "editor.lineHeight" = 1.6;
              "editor.tabSize" = 2;
              "editor.formatOnSave" = true;
              "editor.cursorBlinking" = "smooth";
              "editor.cursorSmoothCaretAnimation" = "on";
              "editor.smoothScrolling" = true;
              "editor.minimap.enabled" = false;
              "workbench.colorTheme" = "Catppuccin Mocha";
              "workbench.iconTheme" = "catppuccin-mocha";
              "workbench.startupEditor" = "none";
              "workbench.tree.indent" = 16;
              "window.titleBarStyle" = "custom";
              "window.menuBarVisibility" = "toggle";
              "terminal.integrated.fontFamily" = "'Maple Mono NF'";
              "terminal.integrated.fontSize" = 13;
              "nix.enableLanguageServer" = true;
              "nix.serverPath" = "nixd";
              "files.autoSave" = "onFocusChange";
              "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
            }
            (
              lib.optionalAttrs cfg.minimal {
                "workbench.activityBar.location" = "hidden";
                "workbench.statusBar.visible" = false;
                "workbench.editor.showTabs" = "none";
                "editor.lineNumbers" = "off";
                "editor.glyphMargin" = false;
                "editor.folding" = false;
                "editor.scrollbar.vertical" = "hidden";
                "editor.scrollbar.horizontal" = "hidden";
                "breadcrumbs.enabled" = false;
                "workbench.layoutControl.enabled" = false;
                "editor.renderLineHighlight" = "none";
                "editor.occurrencesHighlight" = "off";
              }
            )
          )
        );
      };
    };
  };
}
