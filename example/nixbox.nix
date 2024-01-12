{
  ipam = {
    data = import ./ipam;
    nixosConfigurations = {};
  };
  netbox = {
    domain = "https://demo.netbox.dev";
    token-var = "";
  };
}
