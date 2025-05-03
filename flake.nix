{
  description = "Description for the project";

  inputs = {
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs @ {
    git-hooks,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} (let
      systems = import inputs.systems;
    in {
      imports = [
        git-hooks.flakeModule
        ./nix/pre-commit
      ];

      inherit systems;
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };
    });
}
