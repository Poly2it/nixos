{ lib, pkgs, config, ... }:
let
  wallpaper = "springtime.jpg";

  home = config.home.homeDirectory;
  mkPosition = index: lib.hm.gvariant.mkVariant [
    (lib.hm.gvariant.mkDictionaryEntry [ "position" (lib.hm.gvariant.mkVariant index ) ])
  ];
  mkAppLayoutEntry = name: position: (lib.hm.gvariant.mkDictionaryEntry [ name (mkPosition position) ]);
  wallpaperUri = "file://${home}/.local/share/backgrounds/${wallpaper}";
in
{
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/mutter" = {
      center-new-windows = true;
      edge-tiling = true;
    };

    "org/gnome/desktop/interface" = {
      monospace-font-name = "Iosevka 11";
      font-antialiasing = "rgba";
      font-rgba-order = "rgb";
    };

    "org/gnome/desktop/privacy" = {
      disable-camera = true;
      report-technical-problems = false;
      send-software-usage-stats = false;
    };

    "org/gnome/shell/keybinds" = {
      screenshot = [ "<Shift><Super>3" ];
      show-screenshot-ui = [ "<Shift><Super>4" ];
      switch-to-application-1 = [ "" ];
      switch-to-application-2 = [ "" ];
      switch-to-application-3 = [ "" ];
      switch-to-application-4 = [ "" ];
      switch-to-application-5 = [ "" ];
      switch-to-application-6 = [ "" ];
      switch-to-application-7 = [ "" ];
      switch-to-application-8 = [ "" ];
      switch-to-application-9 = [ "" ];
      switch-to-application-10 = [ "" ];
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "small";
    };

    "org/gnome/TextEditor" = {
      use-system-font = false;
      custom-font = "Iosevka 11";
      restore-session = false;
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };

    "io/missioncenter/MissionCenter" = {
      performance-page-cpu-graph = 2;
    };

    "org/gnome/desktop/background" = {
      picture-uri = wallpaperUri;
      picture-uri-dark = wallpaperUri;
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = wallpaperUri;
    };

    "org/gnome/shell" = {
      favorite-apps = [ "org.gnome.Nautilus.desktop" "firefox.desktop" "kitty.desktop" ];
      app-picker-layout = [[
        (mkAppLayoutEntry "org.gnome.TextEditor.desktop" 0)
        (mkAppLayoutEntry "org.gnome.clocks.desktop" 1)
        (mkAppLayoutEntry "org.gnome.Maps.desktop" 2)
        (mkAppLayoutEntry "org.gnome.Weather.desktop" 3)
        (mkAppLayoutEntry "org.gnome.Calculator.desktop" 4)
        (mkAppLayoutEntry "Utilities" 5)
        (mkAppLayoutEntry "File Handlers" 6)
      ]];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "File Handlers" ];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      name = "Utilities";
      apps = [
        "io.missioncenter.MissionCenter.desktop"
        "org.gnome.Logs.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.Settings.desktop"
        "org.gnome.Extensions.desktop"
        "com.github.finefindus.eyedropper.desktop"
        "fr.romainvigier.MetadataCleaner.desktop"
        "nixos-manual.desktop"
        "nvim.desktop"
      ];
      excluded-apps = [
        "org.gnome.FileRoller.desktop"
      ];
      translate = false;
    };

    "org/gnome/desktop/app-folders/folders/File Handlers" = {
      name = "File Handlers";
      apps = [
        "org.gnome.Loupe.desktop"
        "io.github.celluloid_player.Celluloid.desktop"
        "org.gnome.FileRoller.desktop"
      ];
      translate = false;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    gtk3.bookmarks = [
      "file://${home}/documents Documents"
      "file://${home}/downloads Downloads"
      "file://${home}/music Music"
      "file://${home}/pictures Pictures"
      "file://${home}/videos Videos"
      "file:/// Root"
    ];
  };

  home.file.".local/share/backgrounds/" = {
    source = ../wallpapers;
  };
}

