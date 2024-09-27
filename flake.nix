{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable-v3";
  };

  outputs = inputs @ { nixpkgs, home-manager, flatpaks, ... }:
  let
    system = "x86_64-linux";
    inherit (nixpkgs.pkgs) lib;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "cuda-merged"
      ];
    };
    mkUser = username: { configuration, home ? "/home/${username}" }: {
      users.users.${username} = {
        home = home;
        group = "users";
        extraGroups = [ "systemd-journal" ];
        isNormalUser = true;
        initialPassword = "nixos";
      };

      home-manager.users.${username} = configuration;
    };
    mkHost = hostname: { modules }: inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      inherit pkgs;
      modules = [
        ./modules/nix.nix
        ./modules/locale.nix
        ./modules/graphics.nix
        ./modules/sound.nix
        ./modules/gnome.nix
        ./modules/fonts.nix
        ./modules/network.nix
        ./modules/packages.nix
        ./modules/vm.nix
        ./modules/printing.nix
        inputs.chaotic.nixosModules.default
        home-manager.nixosModules.home-manager
        flatpaks.nixosModules.default
        {
          networking.hostName = hostname;
          users.users.gdm = { extraGroups = [ "video" ]; };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "shadowed";
          };
        }
      ] ++ modules;
    }; 
  in
  {
    nixosConfigurations = {
      fractal = mkHost "fractal" {
        modules = [
          ./hosts/fractal.nix
          (mkUser "bach" { configuration = import ./users/bach.nix; })
        ];
      };
      lenoving = mkHost "lenoving" {
        modules = [
          ./hosts/lenoving
          (mkUser "bach" { configuration = import ./users/bach.nix; })
        ];
      };
    };
  };
}

