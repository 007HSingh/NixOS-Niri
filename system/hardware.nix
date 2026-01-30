# Hardware Configuration (base)
# Graphics, Bluetooth - not NVIDIA-specific
{ ... }:

{
  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
  };
}
