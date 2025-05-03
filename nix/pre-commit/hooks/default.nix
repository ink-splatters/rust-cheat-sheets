{
  imports = [
    ./mdbook.nix
    # ./mdformat
  ];
  perSystem = {
    pre-commit.settings.hooks = {
      deadnix.enable = true;
      markdownlint = {
        enable = true;
        settings.configuration = {
          MD041.level = 2;
          MD013.line_length = 110;
        };
      };
      mdformat.enable = true;
      nil.enable = true;
      alejandra.enable = true;
      statix.enable = true;
    };
  };
}
