# System Programs
# Programs enabled via NixOS programs.* options
{ pkgs, ... }:

{
  programs.firefox.enable = true;

  programs.vscode = {
    enable = true;
    extensions = with pkgs; [
      (vscode-with-extensions.override {
        vscode-extensions =
          with vscode-extensions;
          [
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
            jnoortheen.nix-ide
            github.copilot-chat
            github.copilot
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
          ]
          ++ pkgs.vscode-extensionsFromVscodeMarketplace [
            {
              name = "vscode-containers";
              publisher = "ms-azuretools";
              version = "2.4.0";
              sha256 = "0q6c65qh96nl7qdmk58hm2sipcsv3xj9vvfvrvhl4w36k9zbar4q";
            }
          ];
      })
    ];
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
  };

  programs.niri.enable = true;

  programs.starship.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.gpu-screen-recorder.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake /home/harsh/nixos-config#nixos";
      generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      clean = "sudo nix-collect-garbage -d";
    };
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };

  programs.dconf.enable = true;

  programs.evince.enable = true;
}
