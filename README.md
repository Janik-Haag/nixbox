# NixBox

A very work in progress NixOS IPAM implantation.
Trying to integrate with NetBox.

NetBox doesn't model routing topology which sucks for us since we want to know things like the default-gateway to dynamically generate NixOS config.
There are quite a few issues about it, see:
- https://github.com/netbox-community/netbox/discussions/6030


## Usage

You can follow the usage examples, since we can just interact with the demo instance at https://demo.netbox.dev
The login credentials are admin:admin

### Export data from an existing NetBox instance

First we need to get a api token to authenticate against the api.
And store it in `NIXBOX_NETBOX_TOKEN` so NixBox can
```bash
export NIXBOX_NETBOX_TOKEN=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json; indent=4" https://demo.netbox.dev/api/users/tokens/provision/ --data '{ "username": "admin", "password": "admin" }' | jq -r -e .key)
```

Now you can run the NixBox CLI to fetch the data:
```bash
nix run github:Janik-Haag/nixbox -- export
```

### Import data into netbox

NetBox has a concept called datafiles/datasources, you can read about the [here](https://docs.netbox.dev/en/stable/models/core/datafile/)
Currently they only provide a structured interface for importing files, but I'm planning on adding synchronization support to NetBox,
which shouldn't be too hard to pull of since most of the required infrastructure already exists.

In the meantime you can build a demo data file with:
```bash
nix build github:Janik-Haag/nixbox#dataSourceDemo
```

This will result in:
```
./result
└── address
```

You can now go ahead and upload the file on to the demo instance [here](https://demo.netbox.dev/ipam/ip-addresses/import/#tab_upload-form)
And see that it successfully imports the objects from `./example/ipam/ip-addresses.json`.
