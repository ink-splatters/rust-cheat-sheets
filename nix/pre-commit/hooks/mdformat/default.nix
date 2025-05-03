{
  imports = [
    ./mdformat-rustfmt.nix
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }: let
    mdformat = pkgs.mdformat.withPlugins (_: [
      config.packages.mdformat-rustfmt
    ]);
  in {
    pre-commit.settings.hooks.mdformat = {
      enable = true;
      package = mdformat;
      extraPackages = [pkgs.rustfmt];
    };
  };
}
