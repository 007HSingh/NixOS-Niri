# VSCode Configuration
# Moved from system/packages.nix — user-level management via Home Manager
# Allows extension changes without root rebuilds
# Note: lib.mkForce used on userSettings to override Noctalia's vscode module defaults
{
  pkgs,
  lib,
  ...
}:

{
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
            version = "0.37.6";
            sha256 = "19vialjfbpgjrjngmg4f1jwcp9sq670yfnl94v6zmbr6c4bynaml";
          }
        ];

      userSettings = lib.mapAttrs (_: lib.mkForce) {
        "editor.fontFamily" = "'JetBrainsMono Nerd Font Mono', 'JetBrainsMono Nerd Font', monospace";
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
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font Mono'";
        "terminal.integrated.fontSize" = 13;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "files.autoSave" = "onFocusChange";
        "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
    };
  };
}
