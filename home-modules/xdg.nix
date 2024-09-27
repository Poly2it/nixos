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
    extraConfig = {
      "XDG_PROJECTS_DIR" = "${home}/projects";
      "XDG_REPOS_DIR" = "${home}/repos";
      "XDG_CONFIG_HOME" = "${home}/.config";
      "XDG_CACHE_HOME" = "${home}/.local/cache";
      "XDG_DATA_HOME" = "${home}/.local/share";
      "XDG_STATE_HOME" = "${home}/.local/state";
    };
  };
}
