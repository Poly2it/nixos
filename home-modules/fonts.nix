{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    noto-fonts-emoji
    iosevka
    cantarell-fonts
  ];

  fonts.fontconfig.enable = true;
}

