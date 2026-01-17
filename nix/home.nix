{
pkgs,
...
}:
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs;[
    nix
    git
    neovim
    deno
    nil
    markdown-oxide
    ghq
    zsh
    tree-sitter
    clang-tools
    lua-language-server
    ripgrep
    textlint
    # for serena
    uv
  ];
}
