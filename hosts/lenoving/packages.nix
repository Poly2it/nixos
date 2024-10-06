{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mullvad
    mullvad-vpn

    zeroad
  ];

  services.flatpak.packages = [
    "flathub:app/io.github.david_swift.Flashcards//stable"
    "flathub:app/dev.bragefuglseth.Keypunch//stable"
    "flathub:app/io.gitlab.news_flash.NewsFlash//stable"
    "flathub:app/com.github.IsmaelMartinez.teams_for_linux//stable"
    "flathub:app/app.drey.Dialect//stable"
    "flathub:app/io.github.nokse22.Exhibit//stable"
  ];

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.syncthing = {
    enable = true;
    user = "bach";
    dataDir = "/home/bach/sync";
    configDir = "/home/bach/.config/syncthing";
  };
}

