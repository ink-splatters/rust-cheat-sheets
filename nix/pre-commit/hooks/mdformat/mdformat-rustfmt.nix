{
  perSystem = {pkgs, ...}: {
    packages.mdformat-rustfmt = with pkgs.python3Packages;
      buildPythonPackage rec {
        pname = "mdformat-rustfmt";
        version = "0.0.3";
        pyproject = true;

        src = pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-PtgmhNj69bFgABl7vSoDWkUlHOItTBUsW6BLsE9kSrU=";
        };

        build-system = [pkgs.poetry];
        nativeBuildInputs = [poetry-core];
        buildInputs = [mdformat];
      };
  };
}
