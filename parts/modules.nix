{ inputs, ... }:

{
  flake = {
    nixosModules = {
      # ── Automatic discovery ─────────────────────────────────────────────────
      all = inputs.import-tree ../modules/system;

      # ── Host profiles ───────────────────────────────────────────────────────
      profile-predator = import ../profiles/predator.nix;
    };

    homeManagerModules = {
      # ── Automatic discovery ─────────────────────────────────────────────────
      all = inputs.import-tree ../modules/home;

      # ── User profiles ───────────────────────────────────────────────────────
      profile-harsh = import ../profiles/harsh.nix;
    };
  };
}
