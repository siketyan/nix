{
  description = "My monorepo for Nix and NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    vicinae = {
      url = "github:vicinaehq/vicinae/v0.20.15";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    ashell = {
      url = "github:MalpenZibo/ashell/0.8.0";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      treefmt-nix,
      home-manager,
      vicinae,
      ashell,
    }@inputs:
    {
      nixosConfigurations = {
        "82wu" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # NixOS Configuration
            ./82wu/nixos/configuration.nix

            # Nixpkgs Overlays
            {
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = import nixpkgs-unstable {
                    system = final.system;
                    config.allowUnfree = true;
                  };
                })
              ];
            }

            # Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.siketyan = {
                imports = [
                  vicinae.homeManagerModules.default
                  ./82wu/home.nix
                ];
              };
            }
          ];
        };
        b650e = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./b650e/nixos/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "bak";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.siketyan = {
                imports = [
                  vicinae.homeManagerModules.default
                  ./b650e/home.nix
                ];
              };
            }
          ];
        };
      };

      formatter.x86_64-linux = treefmt-nix.lib.mkWrapper nixpkgs.legacyPackages.x86_64-linux {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        settings.formatter.nixfmt.excludes = [ "**/hardware-configuration.nix" ];
      };
    };
}
