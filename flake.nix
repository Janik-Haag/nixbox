{
  description = "A NixOS IPAM implentation hoping to integrate with netbox";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-compat, crane }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          craneLib = crane.lib.${system};
        in
        rec {
          default = cli;
          dataSourceDemo = (import ./utils/builder.nix { inherit (nixpkgs) lib; pkgs = nixpkgs.legacyPackages.${system}; }).dataSource { };
          cli = craneLib.buildPackage {
            src = craneLib.cleanCargoSource (craneLib.path ./cli);
            strictDeps = true;

            # Needed to get openssl-sys to use pkg-config.
            OPENSSL_NO_VENDOR = 1;

            buildInputs = with pkgs; [
              openssl
            ];

            nativeBuildInputs = with pkgs; [
              pkg-config
            ];
          };
        }
      );
      formatter = forAllSystems (
        system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixpkgs-fmt
              nix-unit
              nixdoc
              statix

              # nixbox-cli
              cargo
            ];
          };
        });
    };
}
