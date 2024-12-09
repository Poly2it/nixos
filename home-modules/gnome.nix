{ lib, pkgs, config, ... }:
let
  wallpaper = "springtime.jpg";

  home = config.home.homeDirectory;
  mkPosition = index: lib.hm.gvariant.mkVariant [
    (lib.hm.gvariant.mkDictionaryEntry [ "position" (lib.hm.gvariant.mkVariant index ) ])
  ];
  mkAppLayoutEntry = name: position: (lib.hm.gvariant.mkDictionaryEntry [ name (mkPosition position) ]);
  wallpaperUri = "file://${home}/.local/share/backgrounds/${wallpaper}";
  mkFolder = name: layout: {
    inherit name;
    apps = map (o: o + ".desktop") layout;
    translate = false;
  };
  mkAppLayout = layout: {
    "org/gnome/shell" = {
      app-picker-layout = [(
        lib.lists.imap0
        (i: o: (
          mkAppLayoutEntry
          (if lib.isString o then "${o}.desktop" else o.name)
          i
        ))
        layout
      )];
    };
    "org/gnome/desktop/app-folders" = {
      folder-children = map (o: o.name) (builtins.filter (o: lib.isAttrs o) layout);
    };
  } // (
    lib.listToAttrs
    (
      map (o: {
        name = "org/gnome/desktop/app-folders/folders/${o.name}";
        value = o;
      })
      (builtins.filter (o: lib.isAttrs o) layout)
    )
  );
  mkDash = favorites: {
    "org/gnome/shell" = {
      favorite-apps = map (o: "${o}.desktop") favorites;
    };
  };
in
{
  dconf.settings = lib.pipe (with lib.hm.gvariant; {
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
      default-folder-viewer = "list-view";
    };

    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
      use-tree-view = true;
    };

    "org/gnome/nautilus/preferences" = {
      date-time-format = "detailed";
      default-folder-viewer = "list-view";
    };

    "org/gnome/TextEditor" = {
      use-system-font = false;
      custom-font = "Iosevka 11";
      restore-session = false;
      show-line-numbers = true;
      indent-style = "tab";
      tab-width = mkUint32 8;
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
      window-size = mkTuple [ 860 720 ];
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

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      excluded-apps = [
        "org.gnome.FileRoller.desktop"
      ];
      translate = false;
    };
  }) [
  (x: lib.attrsets.recursiveUpdate x (
    mkAppLayout [
      "org.gnome.TextEditor"
      "org.gnome.clocks"
      "org.gnome.Calendar"
      "org.gnome.Maps"
      "org.gnome.Weather"
      "io.gitlab.news_flash.NewsFlash"
      "signal-desktop"
      "org.gnome.Calculator"
      (mkFolder "Utilities" [
        "io.missioncenter.MissionCenter"
        "org.gnome.Logs"
        "vim"
        "org.gnome.DiskUtility"
        "org.gnome.Settings"
        "org.gnome.Extensions"
        "com.github.finefindus.eyedropper"
        "fr.romainvigier.MetadataCleaner"
        "mullvad-vpn"
      ])
      (mkFolder "File Handlers" [
        "org.gnome.Loupe"
        "io.github.celluloid_player.Celluloid"
        "org.gnome.Papers"
        "io.github.nokse22.Exhibit"
        "io.bassi.Amberol"
        "org.inkscape.Inkscape"
        "org.gnome.FileRoller"
      ])
      (mkFolder "Merriment" [
        "dev.bragefuglseth.Keypunch"
        "0ad"
        "com.valvesoftware.Steam"
        "dev.geopjr.Calligraphy"
      ])
  ]))
  (x: lib.attrsets.recursiveUpdate x (
    mkDash [
      "org.gnome.Nautilus"
      "firefox"
      "firefox-nightly"
      "kitty"
    ])
  )];

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
      "file://${home}/projects Projects"
      "file://${home}/repos Repos"
    ];
  };

  home.file.".local/share/backgrounds/" = {
    source = ../wallpapers;
  };
}

