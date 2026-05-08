{
  description = "My monorepo for Nix and NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      treefmt-nix,
    }@inputs:
    {
      nixosConfigurations = {
        "82wu" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./82wu/nixos/configuration.nix
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
