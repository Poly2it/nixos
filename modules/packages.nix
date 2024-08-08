{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git

    vim
    wl-clipboard

    xdg-terminal-exec-mkhl

    glxinfo

    morewaita-icon-theme
    nautilus
    mission-center
  ];

  programs.neovim = {
    enable = true;
  };
}

