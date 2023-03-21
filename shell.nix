let
  nixos_22_11 = import (fetchTarball {
        name = "nixpkgs-22.11";
        url = "https://github.com/NixOS/nixpkgs/archive/4d2b37a84fad1091b9de401eb450aae66f1a741e.tar.gz";
        sha256 = "11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";

      }) { };
in nixos_22_11.mkShell {
  buildInputs = [
    nixos_22_11.nodejs-18_x
    nixos_22_11.yarn
    nixos_22_11.elmPackages.elm
    nixos_22_11.elmPackages.elm-format
    nixos_22_11.elmPackages.elm-analyse
    nixos_22_11.elmPackages.elm-test
    nixos_22_11.nixfmt
  ];
}
