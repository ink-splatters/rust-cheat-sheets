{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule
    ./pre-commit
  ];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
