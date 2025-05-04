{
  description = "Description for the project";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  nixConfig = {
    extra-substituters = [
      "https://aarch64-darwin.cachix.org"
      "https://pre-commit-hooks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "aarch64-darwin.cachix.org-1:mEz8A1jcJveehs/ZbZUEjXZ65Aukk9bg2kmb0zL9XDA="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: let
      systems = import inputs.systems;
      flakeModules.default = import ./nix/flake-module.nix;
    in {
      imports = [
        flake-parts.flakeModules.partitions
        flakeModules.default
      ];

      config = {
        inherit systems;
        partitionedAttrs = {
          apps = "dev";
          checks = "dev";
          devShells = "dev";
          formatter = "dev";
        };

        partitions.dev = {
          extraInputsFlake = ./nix/dev;
          module = {
            imports = [./nix/dev];
          };
        };

        perSystem = {config, ...}: {
          packages.default = config.packages.rust-cheat-sheets;
        };
        src = ./.;
        flake = {
          inherit flakeModules;
        };
      };

      options.src = lib.mkOption {
        type = lib.types.path;
      };
    });
}
