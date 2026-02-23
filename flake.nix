{
  description = "Tsgo packaged for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      overlay =
        final: _:
        let
          typescript-go = final.callPackage ./typescript_go.nix { };
        in
        {
          inherit typescript-go;
        };
    in
    {
      overlays.default = overlay;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      {
        packages = {
          typescript-go = pkgs.typescript-go;
          default = pkgs.typescript-go;
        };
      }
    );
}
