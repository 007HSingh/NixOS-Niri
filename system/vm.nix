# Virtualisation (KVM/libvirt)
{ pkgs, lib, ... }:

{
  virtualisation.libvirtd = {
    enable = true;

    qemu.ovmf = {
      enable = true;
      packages = [ pkgs.OVMFFull.fd ];
    };

    qemu.swtpm.enable = true;

    qemu.runAsRoot = false;
  };

  programs.virt-manager.enable = true;

  boot.kernelModules = [
    "kvm_intel"
    "kvm_amd"
    "vhost_net"
  ];

  systemd.services.virt-secret-init-encryption.serviceConfig.ExecStart = lib.mkForce [
    ""
    "${pkgs.bash}/bin/bash -c 'umask 0077 && dd if=/dev/random status=none bs=32 count=1 | systemd-creds encrypt --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key'"
  ];
}