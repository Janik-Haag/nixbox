{ lib, ... }: {
  managedByNetbox = lib.mkOption {
    default = false;
    descripton = lib.mdDoc ''
    '';
    type = lib.types.bool;
  };
  comments = lib.mkOption {
    default = null;
    description = lib.mdDoc ''
    '';
    type = lib.types.str;
  };
  description = lib.mkOption {
    default = null;
    description = lib.mdDoc ''
    '';
    type = lib.types.str;
  };
  tags = lib.mkOption {
    default = [ ];
    description = lib.mdDoc ''
    '';
    type = with lib.types; listOf str;
    example = [ "wan" ];
  };
}
