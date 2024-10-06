{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-calendar
    papers
    totem
    inkscape
  ];
}

