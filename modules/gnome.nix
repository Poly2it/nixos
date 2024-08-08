{ pkgs, ... }:

{
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
    sessionPackages = [ pkgs.gnome.gnome-session.sessions ];
  };
  services.xserver.desktopManager = {
    gnome.enable = true;
    # https://discourse.nixos.org/t/fix-gdm-does-not-start-gnome-wayland-even-if-it-is-selected-by-default-starts-x11-instead/24498
    default = "gnome";
  };
  services.xserver.enable = true;

  programs.dconf.enable = true;
}

