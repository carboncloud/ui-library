let
  pkgs = import (fetchTarball {
        name = "nixpkgs-22.11";
        url = "https://github.com/NixOS/nixpkgs/archive/4d2b37a84fad1091b9de401eb450aae66f1a741e.tar.gz";
        sha256 = "11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";

      }) { };
in
with pkgs; mkShell {
  buildInputs = [
    nodejs-18_x
    yarn
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-analyse
    elmPackages.elm-test
    elmPackages.elm-language-server
    elmPackages.elm-review
    nixfmt
  ];
}
