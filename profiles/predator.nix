# Profile: predator
# Enables all system modules for the predator host.
# Imported by hosts/predator/default.nix via inputs.self.nixosModules.profile-predator.
{ ... }:

{
  modules.system = {
    boot.enable = true;
    desktop.enable = true;
    fonts.enable = true;
    hardware.enable = true;
    networking.enable = true;
    nix.enable = true;
    packages.enable = true;
    programs.enable = true;
    security.enable = true;
    services.enable = true;
    stylix.enable = true;
    users.enable = true;
    vm.enable = true;
  };
}
