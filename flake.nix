{
  description = "my common home-manager settings";

  inputs = {
    # flake-utils.url = "github:numtide/flake-utils";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, ...}: {};
  # flake-utils.lib.eachDefaultSystem (
  #   system: {
  #     # 
  #     myConfig = {
  #       modules = [ ./nix/home.nix ];
  #     };
  #   }
  # );
}
