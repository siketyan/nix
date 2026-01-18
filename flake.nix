{
  description = "My monorepo for Nix and NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs } @ inputs: {
    nixosConfigurations = {
      "82wu" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./82wu/nixos/configuration.nix ];
      };
    };
  };
}

