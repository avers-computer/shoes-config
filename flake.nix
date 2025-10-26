{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    helix.url = "github:helix-editor/helix/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";      
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: let
      system = "x86_64-linux";
    in {
    # nixos is hostname
    nixosConfigurations.shoesOS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        # works like specialArgs. Only one is required.
        # { module.args = { inherit inputs; };}
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.shoes = import ./home/default.nix;
        }
      ];
    };


    # nix shell
    devShells.x86_64-linux.node = let
      pkgs = import nixpkgs { inherit system;  };
    in pkgs.mkShell {
      packages = with pkgs; [
        nodejs_24
        (yarn.override { nodejs = nodejs_24; })
      ];

      shellHook = ''
        echo "node `node --version`"
      '';
    };
  };
}
