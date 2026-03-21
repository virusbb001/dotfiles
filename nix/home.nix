{
pkgs,
...
}:
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs;[
    git
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
    nvd
    direnv
    jq
    # for serena
    uv
  ];

  programs.neovim = {
    enable = true;
  };
}
