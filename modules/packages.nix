{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git

    neovim
    vim
    wl-clipboard

    xdg-terminal-exec-mkhl

    glxinfo

    morewaita-icon-theme
    nautilus
    mission-center
    metadata-cleaner
    celluloid
    eyedropper
  ];
}

