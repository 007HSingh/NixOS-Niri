# Hardware Configuration (base)
# Graphics, Bluetooth — not NVIDIA-specific
{ lib, config, ... }:

let
  cfg = config.modules.system.hardware;
in
{
  options.modules.system.hardware.enable =
    lib.mkEnableOption "base hardware support (graphics, bluetooth)";

  config = lib.mkIf cfg.enable {
    hardware = {
      graphics.enable = true;
      bluetooth.enable = true;
    };
  };
}
