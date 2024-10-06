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

  boot.kernelPackages = pkgs.linuxPackages_6_10;
  boot.kernelModules = [ "kvm-intel "];

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/094d9e54-cea0-409f-b63a-d61f76ea1e12";
      preLVM = true;
    };
  };

  networking.hostId = "F33D2333";
}

