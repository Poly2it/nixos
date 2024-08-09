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
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs { inherit system; };
    mkHost = hostname: options: inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      inherit pkgs;
      modules = [
        ./modules/boot.nix
        ./modules/nix.nix
        ./modules/locale.nix
        ./modules/network.nix
        ./modules/graphics.nix
        ./modules/sound.nix
        ./modules/gnome.nix
        ./modules/packages.nix
        ./modules/vm.nix
        ./modules/printing.nix
        inputs.chaotic.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          users.users.gdm = { extraGroups = [ "video" ]; };
          users.users.bach = {
            home = "/home/bach";
            group = "users";
            isNormalUser = true;
            initialPassword = "nixos";
          };

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.backupFileExtension = "shadowed";
          home-manager.users.bach = import ./users/bach.nix;
        }
      ];
    }; 
  in
  {
    nixosConfigurations = {
      fractal = mkHost "fractal" {
        modules = [
          ./hosts/fractal.nix
        ];
      };
    };
  };
}

