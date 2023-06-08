# Emacs package flake

This is a library that I use to define Nix flakes for Emacs packages. It
comes with a number of useful checks:

* Clean bytecode compilation.
* [ERT][ert].
* `checkdoc` test for all `*.el` files.
* [`package-lint`][package-lint] test for all `*.el` files.

The main use case is to have an easy and reliable CI setup for my Emacs lisp
packages.

[ert]: https://www.gnu.org/software/emacs/manual/html_mono/ert.html
[package-lint]: https://github.com/purcell/package-lint

## Example of use

```nix
# flake.nix
{
  inputs = {
    emacs-package-flake.url = "github:mrkkrp/emacs-package-flake";
  };
  outputs = { self, emacs-package-flake }:
    emacs-package-flake.lib.mkOutputs {
      name = "my-package";
      srcDir = ./.;
    };
}
```

Arguments that `mkOutputs` accepts:

* `name` (required)—the name of your package.
* `srcDir` (required)—the directory where your package is located.
* `srcRegex` (optional)—a list of regular expressions that match your source
  files. The default value is `[ "^.*\.el$" "^test.*$" ]`. Ert tests are
  supposed to be in `test` by default.
* `deps` (optional)—a list of strings, names of your dependencies.
* `doErt` (optional)—whether to run Ert tests. Defaults to `false`.
* `doCheckdoc` (optional)—whether to run `checkdoc`. Defaults to `true`.
* `doPackageLint` (optional)—whether to run `package-lint`. Defaults to
  `true`.
* `doCheck` (optional)—the usual Nix attribute, defaults to `true`. You can
  pass `false` if you want to disable all checks.

## Use with GitHub actions

```yaml
# .github/workflows/ci.yaml
name: CI
on:
  push:
    branches:
      - master
  pull_request:
    types:
      - opened
      - synchronize
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: cachix/install-nix-action@v21
      - run: nix build
```

## License

Copyright © 2023–present Mark Karpov

Distributed under the MIT license.
