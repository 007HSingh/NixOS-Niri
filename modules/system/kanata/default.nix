{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.system.kanata;
in
{
  options.modules.system.kanata.enable = lib.mkEnableOption "kanata software keyboard remapper";

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    users.groups = {
      input = { };
      uinput = { };
    };

    users.users.harsh.extraGroups = [
      "input"
      "uinput"
    ];

    services.kanata = {
      enable = true;
      keyboards.default = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            caps  grv
            tab
            lalt  spc  ralt
          )

          (defvar
            tap-timeout 200
            hold-timeout 200
          )

          (defalias
            cap  (tap-hold $tap-timeout $hold-timeout esc lctl)

            nav  (tap-hold $tap-timeout $hold-timeout grv (layer-while-held nav))

            talt (tap-hold $tap-timeout $hold-timeout tab lalt)

            sym  (tap-hold $tap-timeout $hold-timeout spc (layer-while-held sym))

            mou  (tap-hold $tap-timeout $hold-timeout ralt (layer-while-held mouse))
          )

          (deflayer base
            @cap  @nav
            @talt
            lalt  @sym  @mou 
          )

          (deflayer nav
            _     _
            _
            _     _     _
          )

          (deflayer sym
            _     _
            _
            _     _     _
          )

          (deflayer mouse
            _     _
            _
            _     _     _
          )
        '';
      };
    };
  };
}
