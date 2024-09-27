{ pkgs, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  boot.kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
  boot.kernelModules = [ "kvm-intel "];

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/f0182fb7-3af2-4908-ad61-75b2ca315bbe";
      preLVM = true;
    };
  };

  networking.hostId = "71497149";
}

