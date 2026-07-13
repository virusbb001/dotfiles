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
    # zk # I'm using forked version.
    uv # for serena
    vscode-langservers-extracted
  ];

  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    sideloadInitLua = true;
  };
}
