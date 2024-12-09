{ pkgs, ... }:

{
  nix.package = pkgs.nixVersions.latest;

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "20m";
    options = "--delete-older-than 5d";
  };

  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];

  system.stateVersion = "24.11";
}

