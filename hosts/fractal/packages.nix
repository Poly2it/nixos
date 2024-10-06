{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mullvad
    mullvad-vpn

    signal-desktop

    zeroad
  ];

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.flatpak.packages = [
    "flathub:app/dev.bragefuglseth.Keypunch//stable"
    "flathub:app/io.gitlab.news_flash.NewsFlash//stable"
    "flathub:app/com.valvesoftware.Steam//stable"
    "flathub:app/io.github.nokse22.Exhibit//stable"
  ];

  services.syncthing = {
    enable = true;
    user = "bach";
    dataDir = "/home/bach/sync";
    configDir = "/home/bach/.config/syncthing";
  };
}

