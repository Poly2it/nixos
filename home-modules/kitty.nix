{ ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka";
      size = 11;
    };
    extraConfig = ''
      text_composition_strategy platform

      modify_font underline_position 22

      url_color #ffffff
      url_style straight

      copy_on_select no

      strip_trailing_spaces smart

      repaint_delay 6
      input_delay 3
      sync_to_monitor yes

      enable_audio_bell no

      # If only there were draggable window corners.
      hide_window_decorations yes

      tab_bar_edge bottom

      tab_bar_margin_width 0.0
      tab_bar_margin_height 0.0 0.0

      tab_bar_style separator
      tab_separator ""

      tab_title_template " {tab.active_exe} {title} {index} "

      active_tab_foreground   #ffffff
      active_tab_background   #3a3a3a
      active_tab_font_style   normal
      inactive_tab_foreground #8e8e8e
      inactive_tab_background #1e1e1e
      inactive_tab_font_style normal

      tab_bar_background #1e1e1e

      window_margin_width 0
      window_padding_width 0

      wayland_titlebar_color background

      map ctrl+alt+1 goto_tab 1
      map ctrl+alt+2 goto_tab 2
      map ctrl+alt+3 goto_tab 3
      map ctrl+alt+4 goto_tab 4
      map ctrl+alt+5 goto_tab 5
      map ctrl+alt+6 goto_tab 6
      map ctrl+alt+7 goto_tab 7
      map ctrl+alt+8 goto_tab 8
      map ctrl+alt+9 goto_tab 9

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

      foreground #ffffff
      background #1e1e1e
      dim_opacity 0.5

      selection_foreground #000000
      selection_background #ffffff

      # Black
      color0  #1d1d1d
      # Bright Black
      color8  #9a9996
      # Red
      color1  #ed333b
      # Bright Red
      color9  #f66151
      # Green
      color2  #57e389
      # Bright Green
      color10 #8ff04a
      # Yellow
      color3  #ff7800
      # Bright Yellow
      color11 #ffa348
      # Blue
      color4  #62a0ea
      # Bright Blue
      color12 #99c1f1
      # Magenta
      color5  #9141ac
      # Bright Magenta
      color13 #dc8add
      # Cyan
      color6  #5bc8af
      # Bright Cyan
      color14 #93ddc2
      # White
      color7  #deddda
      # Bright White
      color15 #f6f5f4
    '';
  };
}

