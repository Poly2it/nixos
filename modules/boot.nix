{ pkgs, ... }:

{
  boot = {
    loader = {
      grub.enable = true;
      grub.efiSupport = true;
      grub.device = "nodev";
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    kernelPackages = pkgs.linuxPackages_6_8;
  };
}
