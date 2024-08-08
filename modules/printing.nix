{ pkgs, ... }:

{
  services.printing = {
    enable = true;

    # Remove "Manage Printing" .desktop file
    package = pkgs.symlinkJoin {
      inherit (pkgs.cups) name pname version;
      paths = [pkgs.cups];
      postBuild = ''
        unlink $out/share/applications/cups.desktop
      '';
    };
  };
}
