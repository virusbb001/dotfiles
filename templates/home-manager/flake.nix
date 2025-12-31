{
  description = "Home Manager configuration of virus";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles.url = "path:{{DOTFILES_DIR}}";
  };

  outputs =
    { nixpkgs, home-manager, dotfiles, ... }:
    let
      system = "{{NIX_SYSTEM}}";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."{{USER}}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
        ./home.nix
        (dotfiles + "/nix/home.nix")
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
