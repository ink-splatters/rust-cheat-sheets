{
  imports = [
    ./mdformat
  ];
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit = {
      check.enable = true;
      settings.hooks = {
      deadnix.enable = true;
      markdownlint = {
        enable = true;
        settings.configuration = {
          MD041.level = 2;
          MD013.line_length = 110;
        };
      };

      nil.enable = true;
      alejandra.enable = true;
      statix.enable = true;

       mdbook = {
        enable = true;
        name = "mdbook test";
        types = ["markdown"];
        pass_filenames = false;
        package = pkgs.mdbook;
        extraPackages = [pkgs.rustc];
        entry = "${pkgs.mdbook}/bin/mdbook test";
      };
      mdformat = {
        enable = true;
        package = config.packages.mdformat;
        extraPackages = [pkgs.rustfmt];
      };
    };
  };
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
