{ nixpkgs, flake-utils }:
{
  mkOutputs =
    { name
    , srcDir
    , srcRegex ? [ "^.*\.el$" "^test.*\.el$" ]
    , deps ? [ ]
    , doErt ? false
    , doCheckdoc ? true
    , doPackageLint ? true
    , doCheck ? true
    }@attrs:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      attrs0 = {
        buildInputs = [
          (pkgs.emacs28WithPackages (epkgs:
            map
              (x: builtins.getAttr x epkgs)
              (deps ++ (if doErt then [ "ert-runner" ] else [ ])
                ++ (if doPackageLint then [ "package-lint" ] else [ ]))))
        ];
        src = pkgs.lib.sourceByRegex srcDir srcRegex;
        buildPhase = ''
          set -e
          emacs -L . --batch -f batch-byte-compile *.el 2> stderr.txt
          cat stderr.txt
          ! grep -q ': Warning:' stderr.txt || false
        '';
        installPhase = ''
          set -e
          LISPDIR=$out/share/emacs/site-lisp
          install -d $LISPDIR
          install *.el *.elc $LISPDIR
        '';
        checkPhase = ''
          set -e
        '' + pkgs.lib.optionalString doErt ''
          emacs -L . --batch --eval "(progn (require 'ert-runner) (ert-run-tests t (lambda (x) nil)))"
        '' + pkgs.lib.optionalString doCheckdoc ''
          emacs -L . --batch --eval "(progn (require 'checkdoc) (dolist (x command-line-args-left) (checkdoc-file x)))" *.el 2> checkdoc-stderr.txt
          cat checkdoc-stderr.txt
          ! test -s checkdoc-stderr.txt || false
        '' + pkgs.lib.optionalString doPackageLint ''
          emacs -L . --batch --eval "(progn (require 'package-lint) (defun package-lint--check-packages-installable (valid-deps) nil) (package-lint-batch-and-exit))" *.el
        '';
        inherit doCheck;
      };
      myPackage = pkgs.stdenv.mkDerivation (attrs0 // attrs);
    in
    {
      packages.default = myPackage;
    });
}
