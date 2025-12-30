{
config,
pkgs,
...
}:
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs;[
    git
    neovim
    deno
    nil
    markdown-oxide
  ];
}
