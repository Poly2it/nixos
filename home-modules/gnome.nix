{ pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/shell" = {
      "favorite-apps" = [ "org.gnome.Nautilus.desktop" "firefox.desktop" "kitty.desktop" ];
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };
}

