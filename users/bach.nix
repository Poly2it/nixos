{ pkgs, ... }:

{
  home.packages = with pkgs; [
    atool
    httpie
  ];
  programs.bash.enable = true;

  home.stateVersion = "24.11"; 
}

