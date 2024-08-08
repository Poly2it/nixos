{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git

    vim
    wl-clipboard

    xdg-terminal-exec-mkhl

    morewaita-icon-theme
    nautilus
  ];

  programs.neovim = {
    enable = true;
  };
}

