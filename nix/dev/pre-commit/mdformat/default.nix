{
  imports = [
    ./mdformat-rustfmt.nix
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages.mdformat = pkgs.mdformat.withPlugins (_: [
      config.packages.mdformat-rustfmt
    ]);
  };
  
}
