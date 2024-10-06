{ lib, pkgs, ... }:

{
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.displayManager.sessionPackages = [ pkgs.gnome-session.sessions ];
  services.xserver.desktopManager = {
    gnome.enable = true;
    # https://discourse.nixos.org/t/fix-gdm-does-not-start-gnome-wayland-even-if-it-is-selected-by-default-starts-x11-instead/24498
  };
  services.xserver.modules = [ pkgs.xorg.xf86videofbdev ];
  services.xserver.videoDrivers = [ "hyperv_fb" ];
  services.xserver.enable = true;

  programs.dconf.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    baobab      # disk usage analyzer
    epiphany    # web browser
    gedit       # text editor
    simple-scan # document scanner
    totem       # video player
    yelp        # help center
    evince      # document reader
    snapshot    # camera
    geary       # email client
    seahorse    # password manager
    gnome-tour
    gnome-system-monitor
    gnome-font-viewer
    gnome-console
    gnome-font-viewer
    gnome-connections
    gnome-calendar
    gnome-characters
    gnome-music
    gnome-software
    gnome-contacts
  ];

  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];
}

