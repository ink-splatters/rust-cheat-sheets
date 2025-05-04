{
  imports = [
    ./hooks
  ];
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit.check.enable = true;
    apps.install-hooks = {
      type = "app";
      program = toString (pkgs.writeShellScript "install-hooks" ''
        ${config.pre-commit.installationScript}
        echo Done!
      '');
      meta.description = "install pre-commit hooks";
    };
    devShells.default = config.pre-commit.devShell;
  };
}
