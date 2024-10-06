{ lib, pkgs, ... }:

let
  hiddenApps = [ "nvim.desktop" "nixos-manual.desktop" "org.gnome.Totem.desktop" ];

  hiddenDesktopFile = pkgs.writeText "hidden.desktop" ''
    [Desktop Entry]
    Hidden=true
    NoDisplay=true
  '';
  hiddenAppsPackage = pkgs.runCommandLocal "hidden-apps" {} ''
    mkdir -p $out/share/applications
    for app in ${lib.escapeShellArgs hiddenApps}; do
      ln -sf ${hiddenDesktopFile} "$out/share/applications/$app"
    done
  '';
in

{
  options.desktop = {
    hiddenApps = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };
  };
  config = lib.mkIf (hiddenApps != []) {
    home.packages = [
      (lib.hiPrio hiddenAppsPackage)
    ];
  };
}

