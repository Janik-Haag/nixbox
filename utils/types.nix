{ lib, ... }: rec {
  ipv4Address = lib.types.mkOptionType {
    name = "ipv4Address";
    description = "";
    check = "todo";
  };
  ipv6Address = lib.types.mkOptionType {
    name = "ipv6Address";
    description = "";
    check = "todo";
  };
  ipAddress = lib.types.mkOptionType {
    name = "ipv6Address";
    description = "";
    check = "oneOf [ ipv4Address ipv6Address ]";
  };
  ipv4AddressWithMask = lib.types.mkOptionType {
    name = "ipv4AddressWithMask";
    description = "";
    check = "ipv4Address+/[0-32]";
  };
  ipv6AddressWithMask = lib.types.mkOptionType {
    name = "ipv6AddressWithMask";
    description = "";
    check = "ipv6Address+/[0-128]";
  };
}
