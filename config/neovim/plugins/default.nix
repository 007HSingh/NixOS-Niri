{ config, lib, ... }:

{
  imports = [
    ./ui.nix
    ./editor.nix
    ./lsp.nix
    ./completion.nix
    ./git.nix
    ./treesitter.nix
    ./telescope.nix
    ./utilities.nix
  ];
}
