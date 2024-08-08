{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka";
      size = 10;
    };
    extraConfig = ''
      # Seti-UI + Custom
      symbol_map U+E5FA-U+E62B Symbols Nerd Font
      # Devicons
      symbol_map U+E700-U+E7C5 Symbols Nerd Font
      # Font Awesome
      symbol_map U+F000-U+F2E0 Symbols Nerd Font
      # Font Awesome Extension
      symbol_map U+E200-U+E2A9 Symbols Nerd Font
      # Material Design Icons
      symbol_map U+F0001-U+F1AF0 Symbols Nerd Font
      # Weather
      symbol_map U+E300-U+E3E3 Symbols Nerd Font
      # Octicons
      symbol_map U+F400-U+F532,U+2665-U+26A1 Symbols Nerd Font
      # Powerline Extra Symbols
      symbol_map U+E0A0-U+E0A2,U+E0B0-U+E0B3 Symbols Nerd Font
      # IEC Power Symbols
      symbol_map U+23FB-U+23FE,U+2B58 Symbols Nerd Font
      # Font Logos
      symbol_map U+F300-U+F372 Symbols Nerd Font
      # Pomicons
      symbol_map U+E000-U+E00A Symbols Nerd Font
      # Codicons
      symbol_map U+E060-U+EBEB Symbols Nerd Font
      # Heavy Angle Brackets
      symbol_map U+E276C-U+E2771 Symbols Nerd Font
      # Box Drawing
      symbol_map U+2500-U+259F Symbols Nerd Font
    '';
  };
}

