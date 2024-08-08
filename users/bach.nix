{ ... }:

{
  imports  = [
    ../home-modules/shell.nix
    ../home-modules/gnome.nix
    ../home-modules/gnome-extensions.nix
    ../home-modules/fonts.nix
    ../home-modules/kitty.nix
    ../home-modules/firefox.nix
  ];

  home.stateVersion = "24.11"; 
}

