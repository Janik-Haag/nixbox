use clap::{Parser, Subcommand};
use serde::{Serialize, Deserialize};
// use tvix_serde;
use std::net::IpAddr;
use std::{env, path::PathBuf};
use std::error;
use std::fs;
use std::io::Write;

#[derive(Parser, Debug)]
#[clap(version)]
struct Args {
    #[command(subcommand)]
    cmd: SubCommands,
}

#[derive(Subcommand, Debug)]
enum SubCommands {
    Add {
        #[clap(long, short, action)]
        ips: bool,
    },
    Export {
        #[clap(short, long)]
        ips: bool,

        #[clap(short, long)]
        location: Option<PathBuf>,
    },
}

#[derive(Debug, Serialize, Deserialize)]
struct IpAddresses {
    address: IpAddr, // TODO(Janik): make it use CIDR
    status: String, // TODO(Janik): enum actual netbox values
    dns_name: String,
    tags: Vec<String>
}

fn netbox_api_request(url: String) -> Result<String, Box<dyn error::Error>> {
    // TODO(Janik): throw a error if var is unset and do http status code checks for client.get
    let token = env::var("NIXBOX_NETBOX_TOKEN")?;
    let client = reqwest::blocking::Client::new();

    // We can't use the bearer auth method because netbox doesn't comply with the standards.
    let resp = client.get(url).header("Authorization", "Token ".to_owned() + &token).send()?;
    let json = resp.json::<serde_json::Value>()?;
    Ok(json.to_string())
}

#[derive(Serialize, Deserialize, Debug)]
struct Nix {
    a: String,
    b: u32
}

// this is currently stuck on https://cl.tvl.fyi/c/depot/+/10581
// because we need import functionality to pull in and eval the users config
// the code here is just a filler example to make it compile happily
fn get_current_config() -> Result<Nix, Box<dyn error::Error>> {
    let deserialized: Result<Nix, Box<dyn error::Error>> = Ok(tvix_serde::from_str::<Nix>("lib.attrsets.recursiveUpdate { a = \"coding with tvix!\"; } { b = 231; }")?);
    deserialized
}

fn add(ips: bool) -> Result<(), Box<dyn error::Error>> {
    if ips {
    }
    Ok(())
}

fn export(ips: bool, location: Option<PathBuf>) -> Result<(), Box<dyn error::Error>>{
    let location = location.unwrap_or_else(|| PathBuf::from("/tmp/nixbox_export"));
    fs::create_dir_all(location.clone())?;
    if ips {
        let mut ips_file = fs::File::create(location.to_str().unwrap().to_owned() + "ips.json")?;
        let _ = ips_file.write_all((netbox_api_request(String::from("https://demo.netbox.dev/api/ipam/ip-addresses"))?).as_bytes());
    }
    Ok(())
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn error::Error>> {
    let args = Args::parse();
    let _ = match args.cmd {
        SubCommands::Add { ips } => add(ips),
        SubCommands::Export { ips, location } => export(ips, location),
    };
    Ok(())
}
