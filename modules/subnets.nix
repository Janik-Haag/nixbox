{ utils }: { lib, config, ... }: {
  options = {
    subnets = with lib.types; listOf (submodule {
      options = (import ./common.nix { inherit lib config; }) // {
        address = lib.mkOption {
          description = lib.mdDoc ''
          '';
          type = utils.types.ipAddressWithMask;
        };
        defaultGateway = lib.mkOption {
          description = lib.mdDoc ''
          '';
          type = utils.types.ipAddressWithMask;
        };
      };
    });
  };
  config = {
  };
}
