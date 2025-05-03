{
  perSystem = {pkgs, ...}: {
    pre-commit.settings.hooks.mdbook = {
      enable = true;
      name = "mdbook test";
      types = ["markdown"];
      pass_filenames = false;
      package = pkgs.mdbook;
      extraPackages = [pkgs.rustc];
      entry = "${pkgs.mdbook}/bin/mdbook test";
    };
  };
}
