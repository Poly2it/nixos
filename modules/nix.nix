{ pkgs, ... }:

{
  nix.package = pkgs.nixVersions.latest;

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "20m";
    options = "--delete-older-than 5d";
  };

  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}

