{ config, lib, utils }:
{
  options = {
    nixbox = {
      serviceTemplate = lib.types.attrsOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = ''
              A service or protocol name.
            '';
            type = lib.types.str;
            example = "https";
          };
          protocol = lib.mkOption {
            description = ''
              The wire protocol on which the service runs.
            '';
            type = lib.types.enum [ "tcp" "udp" "sctp" ];
            example = "tcp";
          };
          ports = lib.mkOption {
            description = ''
              One or more numeric ports to which the service is bound. Multiple ports can be expressed using lists and `utils.networking.portrange`.
            '';
            type = lib.types.listOf lib.types.int;
            example = [ 443 ];
          };
        };
      });
      servicePrests = { };
    };
  };
  config = {
    nixbox = { };
  };
}
