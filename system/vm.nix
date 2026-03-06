{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  users.users.harsh.extraGroups = [ "libvirtd" ];

  boot.kernelModules = [ "kvm_intel" ];

  # Fix: libvirt's virt-secret-init-encryption.service hardcodes /usr/bin/sh
  # which doesn't exist on NixOS. Override ExecStart to use the correct path.
  systemd.services.virt-secret-init-encryption = {
    serviceConfig.ExecStart = pkgs.lib.mkForce [
      ""
      "${pkgs.bash}/bin/sh -c 'umask 0077 && (dd if=/dev/random status=none bs=32 count=1 | systemd-creds encrypt --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key)'"
    ];
  };
}