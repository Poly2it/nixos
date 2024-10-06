{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    noto-fonts-emoji
    iosevka
    cantarell-fonts
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    noto-fonts-extra
  ];
}

