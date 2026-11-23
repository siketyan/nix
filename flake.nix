{
  description = "My monorepo for Nix and NixOS configs";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
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
      url = "github:MalpenZibo/ashell/0.12.1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
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
      llm-agents,
    }@inputs:
    {
      nixosConfigurations = {
        "82wu" = nixpkgs-unstable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            # NixOS Configuration
            ./82wu/nixos/configuration.nix

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
        ms01 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./ms01/nixos/configuration.nix
            ({ pkgs, ... }: {
              environment.systemPackages = with llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
                claude-code
                codex
              ];
              users.users.siketyan.packages = [
                ashell.packages.${pkgs.stdenv.hostPlatform.system}.default
              ];
            })
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
