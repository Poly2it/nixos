{ pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    rounded-window-corners-reborn
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "rounded-window-corners@fxgn"
      ];
    };

    "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
      tweak-kitty-terminal = true;
    };
  };
}

