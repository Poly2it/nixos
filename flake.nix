{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs { inherit system; };
    mkHost = { hostname, options }: inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      inherit pkgs;
      modules = [ 
        ./modules/boot.nix { inherit pkgs; }
        ./modules/nix.nix { inherit pkgs; }
        ./modules/locale.nix
        ./modules/network.nix { inherit hostname; }
        ./modules/graphics.nix { inherit pkgs; }
        ./modules/sound.nix
        ./modules/gnome.nix { inherit pkgs; }
        ./modules/packages.nix { inherit pkgs; }
        inputs.chaotic.nixosModules.default
        {
          users.users.bach = {
            isNormalUser = true;
            initalPassword = "nixos";
          };
        }
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bach = import ./home.nix;
        }
      ];
    }; 
  in
  {
    nixosConfigurations = {
      fractal = mkHost {
        hostname = "fractal";
        options = {
          modules = [
            ./hosts/fractal.nix
          ];
        };
      };
    };
  };
}

