{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git

    vim
    neovim
    wl-clipboard

    kitty

    xdg-terminal-exec-mkhl

    morewaita-icon-theme
    nautilus
  ];

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];
}

