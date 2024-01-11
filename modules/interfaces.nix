{ utils }: { lib, ... }: {
  name = lib.mkOption {
    description = lib.mdDoc ''
    '';
    example = "eth0";
    type = lib.types.str;
  };
  mac = lib.mkOption {
    default = null;
    description = lib.mdDoc ''
    '';
    type = lib.types.nullOr lib.types.str;
  };
  speed = lib.mkOption {
    default = 1000000;
    description = lib.mdDoc ''
      in Kbps
    '';
    type = lib.types.int;
  };
}
