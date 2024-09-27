{ ... }:

{
  imports  = [
    ../home-modules/shell.nix
    ../home-modules/gnome.nix
    ../home-modules/gnome-extensions.nix
    ../home-modules/fonts.nix
    ../home-modules/kitty.nix
    ../home-modules/firefox.nix
    ../home-modules/hidden-apps.nix
    ../home-modules/xdg.nix
    ../home-modules/packages.nix
  ];

  home.stateVersion = "24.11"; 

  home.shellAliases = {
    nvim = "nix run \"$\{HOME}/.config/nvim\"";
  };
}

