{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    noto-fonts-emoji
    iosevka
  ];

  fonts.fontconfig.enable = true;
}

