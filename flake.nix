{
  description = "A NixOS IPAM implentation hoping to integrate with netbox";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    flake-utils.url = "github:numtide/flake-utils";

    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-compat, flake-utils, crane }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        craneLib = crane.lib.${system};

        # Common derivation arguments used for all builds
        cliCommonArgs = {
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
        cliCargoArtifacts = craneLib.buildDepsOnly (cliCommonArgs // {
          pname = "nixbox-cli-deps";
        });
        cliClippy = craneLib.cargoClippy (cliCommonArgs // {
          cargoArtifacts = cliCargoArtifacts;
          cargoClippyExtraArgs = "--all-targets -- --deny warnings";
        });

        cliCrate = craneLib.buildPackage (cliCommonArgs // {
          cargoArtifacts = cliCargoArtifacts;
        });

        cliCoverage = craneLib.cargoTarpaulin (cliCommonArgs // {
          cargoArtifacts = cliCargoArtifacts;
        });
      in
      {
        packages =
          {
            default = cliCrate;
            cli = cliCrate;
            dataSourceDemo = (import ./utils/builder.nix { inherit (nixpkgs) lib; pkgs = nixpkgs.legacyPackages.${system}; }).dataSource { };
          };
        formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt
        ;
        devShells = {
          default = craneLib.devShell {
            checks = self.checks.${system};
            inputsFrom = [
              cliCrate
            ];
            packages = with pkgs; [
              nixpkgs-fmt
              nix-unit
              nixdoc
              statix
            ];
          };
        };
        checks = {
          inherit
            cliCrate
            cliClippy
            # cliCoverage // not yet used
            ;
        };
      })) // {
      tests = nixpkgs.lib.mapAttrs (name: v: import "${./utils}/tests/${name}.nix" { inherit self; inherit (nixpkgs) lib; inherit (self) utils; }) (builtins.removeAttrs self.utils [ "__unfix__" "extend" "generate" ]);
      utils = import ./utils { inherit (nixpkgs) lib; };
      nixosModules = rec {
        nixbox = import ./modules/nixbox.nix { inherit (self) utils; };
        default = nixbox;
      };
    };
}
