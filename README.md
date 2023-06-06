# Emacs package flake

This is a library that I use to define Nix flakes for Emacs packages. It
comes with a number of useful checks:

* (ERT)[https://www.gnu.org/software/emacs/manual/html_mono/ert.html].
* `checkdoc` test for all `*.el` files.
* [`package-lint`](https://github.com/purcell/package-lint) test for all
  `*.el` files.

The main use case is to have an easy and reliable CI setup for my Emacs lisp
packages.

## Example of use

TODO

## License

Copyright © 2023–present Mark Karpov

Distributed under the MIT license.
