# Requirement

## MacOS / Linux

* [Nix](https://nixos.org/)

## When you cannot install nix

* [Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)
* [Deno](https://docs.deno.com/runtime/getting_started/installation/)
* [TreeSitter CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)

# HowToUse

```sh
git clone https://github.com/virusbb001/dotfiles.git dotfiles
cd dotfiles
git submodule init
git submodule update
nix develop --command ./installer.sh
```
