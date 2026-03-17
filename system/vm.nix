# Virtualisation (KVM/libvirt)
{ pkgs, lib, ... }:

{
  virtualisation.libvirtd = {
    enable = true;

    qemu.swtpm.enable = true;

    qemu.runAsRoot = false;

    allowedBridges = [ "virbr0" ];
  };

  systemd.services.libvirt-default-network = {
    description = "Start libvirt default network";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
      ExecStartPost = "${pkgs.libvirt}/bin/virsh net-autostart default";
    };
    serviceConfig.SuccessExitStatus = [ 1 ];
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