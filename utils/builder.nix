{ pkgs, lib, ... }: rec {
  dataFile = type: data:
    builtins.toFile type (builtins.toJSON (lib.mapAttrsToList (n: v: { ${type} = n; } // v) data))
  ;
  dataSource = data:
    pkgs.linkFarm "dataFiles" (
      lib.mapAttrsToList
        (
          n: v: {
            name = n;
            path = dataFile n v;
          }
        )
        {
          address = builtins.fromJSON (builtins.readFile ../example/ipam/ip-addresses.json);
        }
    )
  ;
}
