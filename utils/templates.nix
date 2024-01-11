{ lib, utils, ... }:
{
  networkd = {
    mkWanInterface = host: {
      # disable dhcp since we use static ips;
      networkConfig.DHCP = "no";
      # utils.match.ips is not yet implemented
      # but once it is it should return attrset of all the ips
      # matching the domain in `host`, something like `host1.example.com`
      # and the label `wan`
      address = lib.attrNames (utils.match.ips host "wan");
      matchConfig.Name = (utils.match.devieces host).interfaces;
      linkConfig.RequiredForOnline = "routable";
      routes = [
      ];
    };
  };
}
