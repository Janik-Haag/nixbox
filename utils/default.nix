{ lib }:
let
  utils = lib.makeExtensible (self:
    let
      callUtils = file: import file { inherit lib; utils = self; };
    in
    {
      networking = callUtils ./networking.nix;
    });
in
utils
