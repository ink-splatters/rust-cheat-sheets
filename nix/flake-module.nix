{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.rust-cheat-sheets = pkgs.stdenv.mkDerivation {
      name = "rust-cheat-sheets";
      inherit (config) src;

      buildPhase = ''
        mdbook build
      '';
      installPhase = ''
        mkdir $out
        mv book $out/
      '';

      nativeBuildInputs = [pkgs.mdbook];
    };
  };
}
