# SingLinkVPN for Linux

Official installation entry point for the SingLinkVPN Linux desktop client.

## Preview release

ARM64 version 2.5.8 is published in the Snap Store's **edge** testing channel.
AMD64 packaging and account-based VPN testing are in progress. There is no stable release yet.

Download and run the installer (Bash):

```bash
sh <(wget -qO - https://raw.githubusercontent.com/SingLinkNetwork/singlinkvpn-linux/main/install.sh) -p singlinkvpn-gui --channel edge
```

Or download it first for inspection:

```sh
wget -O install.sh https://raw.githubusercontent.com/SingLinkNetwork/singlinkvpn-linux/main/install.sh
sh install.sh -p singlinkvpn-gui --channel edge
```

The script installs the signed Snap Store package, connects the network-control and firewall-control interfaces required by the VPN, and restarts its service. It requires sudo access. A SingLink account is required to use the service.

Launch from your application menu or run `snap run singlinkvpn`.

- Store: https://snapcraft.io/singlinkvpn
- Website: https://singlinkvpn.com

The installer defaults to `stable`; use `--channel edge` while the preview is being tested.
