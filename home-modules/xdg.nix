{ pkgs, config, ... }:
let
  home = config.home.homeDirectory;
in
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-desktop-portal-hyprland
    ];

    config.common.default = "gnome";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    documents = "${home}/documents";
    download = "${home}/downloads";
    music = "${home}/music";
    pictures = "${home}/pictures";
    videos = "${home}/videos";
    desktop = null;
    publicShare = null;
    templates = null;
  };
}