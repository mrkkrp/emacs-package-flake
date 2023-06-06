{
  description = "A library that facilitates definition of flakes for Emacs packages";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: {
    lib = import ./lib.nix {
      inherit nixpkgs;
      inherit flake-utils;
    };
  };
}
